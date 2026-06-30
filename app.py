import os
import json
import hashlib
import socket
import threading
import time
from collections import defaultdict
from datetime import datetime
from functools import wraps
from threading import Lock

from flask import Flask, render_template, request, redirect, url_for, session, jsonify
import mysql.connector
from scapy.all import sniff, ARP, IP, TCP, UDP
from scapy.arch.windows import get_windows_if_list


# ═══════════════════════════════════════════════════════════
#  DATABASE
# ═══════════════════════════════════════════════════════════
class Database:
    CONFIG = {
        'host':     'localhost',
        'user':     'root',
        'password': '',
        'database': 'network_monitor',
    }

    @staticmethod
    def get_connection():
        return mysql.connector.connect(**Database.CONFIG)


# ═══════════════════════════════════════════════════════════
#  AUDIT LOGGER
# ═══════════════════════════════════════════════════════════
class AuditLogger:

    @staticmethod
    def _get_client_ip():
        for header in ('X-Forwarded-For', 'X-Real-IP'):
            value = request.headers.get(header)
            if value:
                return value.split(',')[0].strip()
        return request.remote_addr or '0.0.0.0'

    @staticmethod
    def save(action, status='success', username='', user_id=None, ip_address=None):
        """
        ip_address is accepted as an explicit argument so this method can be
        called safely from background threads (where request context is absent).
        When called from a route handler, leave ip_address=None and the client
        IP is read from the current request.
        """
        try:
            if ip_address is None:
                ip_address = AuditLogger._get_client_ip()
        except RuntimeError:
            ip_address = '0.0.0.0'

        conn = Database.get_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                """INSERT INTO activity_logs
                   (user_id, username, action, ip_address, status, created_at)
                   VALUES (%s, %s, %s, %s, %s, %s)""",
                (user_id, username, action, ip_address, status, datetime.now()),
            )
            conn.commit()
        except Exception as exc:
            print(f"[LOG ERROR] {exc}")
        finally:
            cursor.close()
            conn.close()


# ═══════════════════════════════════════════════════════════
#  ALERT MANAGER
# ═══════════════════════════════════════════════════════════
class AlertManager:

    @staticmethod
    def save(alert_type, source_ip, details):
        conn = Database.get_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                """INSERT INTO network_alerts
                   (alert_type, source_ip, details, timestamp)
                   VALUES (%s, %s, %s, %s)""",
                (alert_type, source_ip, json.dumps(details), datetime.now()),
            )
            conn.commit()
        finally:
            cursor.close()
            conn.close()

    @staticmethod
    def get_all():
        conn = Database.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                "SELECT * FROM network_alerts ORDER BY timestamp DESC"
            )
            alerts = cursor.fetchall()
        finally:
            cursor.close()
            conn.close()

        for alert in alerts:
            if isinstance(alert['details'], str):
                alert['details'] = json.loads(alert['details'])
            alert['timestamp'] = str(alert['timestamp'])
        return alerts


# ═══════════════════════════════════════════════════════════
#  WHITELIST
# ═══════════════════════════════════════════════════════════
def get_own_ips():
    """
    Detects all IP addresses belonging to the machine running ThreatMon
    (e.g. the Wi-Fi adapter, VirtualBox/VMware adapters, loopback) so the
    detectors never flag this host's own traffic as an attack.
    """
    ips = {'127.0.0.1'}

    # All IPs registered to the local hostname (covers most adapters)
    try:
        hostname = socket.gethostname()
        _, _, addr_list = socket.gethostbyname_ex(hostname)
        ips.update(addr_list)
    except Exception as exc:
        print(f"[SELF-WHITELIST] hostname lookup failed: {exc}")

    # The IP actually used for outbound traffic (most reliable for the
    # primary adapter, e.g. the Wi-Fi IP)
    s = None
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.settimeout(1)
        s.connect(('8.8.8.8', 80))
        ips.add(s.getsockname()[0])
    except Exception as exc:
        print(f"[SELF-WHITELIST] outbound IP lookup failed: {exc}")
    finally:
        if s:
            s.close()

    return ips


class WhitelistManager:
    """Persists manually-whitelisted IPs in MySQL."""

    @staticmethod
    def get_all():
        conn = Database.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                "SELECT * FROM whitelist_ips ORDER BY added_at DESC"
            )
            rows = cursor.fetchall()
        finally:
            cursor.close()
            conn.close()
        for row in rows:
            row['added_at'] = str(row['added_at'])
        return rows

    @staticmethod
    def add(ip_address, label=''):
        conn = Database.get_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                """INSERT INTO whitelist_ips (ip_address, label, added_at)
                   VALUES (%s, %s, %s)
                   ON DUPLICATE KEY UPDATE label = VALUES(label)""",
                (ip_address, label, datetime.now()),
            )
            conn.commit()
        finally:
            cursor.close()
            conn.close()

    @staticmethod
    def remove(entry_id):
        conn = Database.get_connection()
        try:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM whitelist_ips WHERE id = %s", (entry_id,))
            conn.commit()
        finally:
            cursor.close()
            conn.close()


# Auto-detected own-device IPs, resolved once at startup
AUTO_OWN_IPS = get_own_ips()

# Live set shared (by reference) with every detector's WHITELIST attribute.
# Mutated in place via refresh_whitelist() so detectors always see updates
# without needing to be re-instantiated.
WHITELIST_CACHE = set(AUTO_OWN_IPS)


def refresh_whitelist():
    """Reloads WHITELIST_CACHE from AUTO_OWN_IPS + the DB-backed whitelist."""
    try:
        manual_ips = {row['ip_address'] for row in WhitelistManager.get_all()}
    except Exception as exc:
        print(f"[WHITELIST] failed to load manual entries: {exc}")
        manual_ips = set()

    WHITELIST_CACHE.clear()
    WHITELIST_CACHE.update(AUTO_OWN_IPS)
    WHITELIST_CACHE.update(manual_ips)


refresh_whitelist()


# ═══════════════════════════════════════════════════════════
#  INTERFACE DETECTOR
# ═══════════════════════════════════════════════════════════
class InterfaceDetector:
    """
    Picks the network adapter ThreatMon should actually sniff on.

    A hardcoded iface='Wi-Fi' misses traffic from devices connected to a
    mobile hotspot hosted from this machine, since Windows routes that
    through a separate virtual adapter (e.g. "Local Area Connection* X").
    This auto-selects the adapter currently carrying real traffic instead.
    """
    SKIP_KEYWORDS = ('virtualbox', 'vmware', 'bluetooth', 'loopback', 'hyper-v')

    @staticmethod
    def get_best_interface():
        try:
            interfaces = get_windows_if_list()
        except Exception as exc:
            print(f"[INTERFACE] could not list interfaces: {exc}")
            return 'Wi-Fi'

        # 1) Prefer whichever adapter's IP matches our own detected IPs
        #    (this naturally follows you onto a hotspot adapter if Windows
        #    is currently routing through it).
        for iface in interfaces:
            name = iface.get('name', '')
            ips  = iface.get('ips', [])
            lname = name.lower()
            if any(kw in lname for kw in InterfaceDetector.SKIP_KEYWORDS):
                continue
            if any(ip in AUTO_OWN_IPS for ip in ips):
                print(f"[INTERFACE] Selected by IP match: {name}")
                return name

        # 2) Fallback: first non-virtual adapter that has a real IPv4 address
        for iface in interfaces:
            name = iface.get('name', '')
            lname = name.lower()
            if any(kw in lname for kw in InterfaceDetector.SKIP_KEYWORDS):
                continue
            ips = [ip for ip in iface.get('ips', []) if ip and ip != '0.0.0.0']
            if ips:
                print(f"[INTERFACE] Selected by fallback: {name}")
                return name

        print("[INTERFACE] No suitable interface found, defaulting to 'Wi-Fi'")
        return 'Wi-Fi'


# ═══════════════════════════════════════════════════════════
#  ARP SPOOF DETECTOR
# ═══════════════════════════════════════════════════════════
class ArpSpoofDetector:
    WINDOW    = 30   # seconds
    THRESHOLD = 3    # unique MACs before alerting
    COOLDOWN  = 15   # seconds between alerts for the same IP
    WHITELIST = WHITELIST_CACHE

    def __init__(self):
        self.ip_mac_table = {}
        self.arp_history  = defaultdict(list)
        self.arp_cooldown = {}
        self.lock         = Lock()

    def detect(self, pkt):
        if not pkt.haslayer(ARP) or pkt[ARP].op != 2:
            return

        src_ip  = pkt[ARP].psrc
        src_mac = pkt[ARP].hwsrc.lower()
        now     = time.time()

        if src_mac in ('ff:ff:ff:ff:ff:ff', '00:00:00:00:00:00'):
            return
        if src_ip in self.WHITELIST:
            return

        with self.lock:
            if src_ip not in self.ip_mac_table:
                self.ip_mac_table[src_ip] = src_mac
                self.arp_history[src_ip].append((src_mac, now))
                return

            # Prune old entries
            self.arp_history[src_ip] = [
                (mac, t) for mac, t in self.arp_history[src_ip]
                if now - t <= self.WINDOW
            ]
            self.arp_history[src_ip].append((src_mac, now))
            unique_macs = {mac for mac, _ in self.arp_history[src_ip]}

            if len(unique_macs) < self.THRESHOLD:
                if src_mac != self.ip_mac_table[src_ip]:
                    self.ip_mac_table[src_ip] = src_mac
                return

            if now - self.arp_cooldown.get(src_ip, 0) < self.COOLDOWN:
                return

            AlertManager.save('ARP Spoofing', src_ip, {
                'trusted_mac':   self.ip_mac_table[src_ip],
                'attacker_macs': list(unique_macs - {self.ip_mac_table[src_ip]}),
                'description':   (
                    f"IP {src_ip} claimed {len(unique_macs)} different MACs "
                    f"within {self.WINDOW}s."
                ),
                'action': (
                    'Verify devices on the network. '
                    'Enable Dynamic ARP Inspection if possible.'
                ),
            })

            self.arp_cooldown[src_ip]  = now
            self.arp_history[src_ip]   = [(src_mac, now)]
            self.ip_mac_table[src_ip]  = src_mac


# ═══════════════════════════════════════════════════════════
#  DDOS DETECTOR
# ═══════════════════════════════════════════════════════════
class DDoSDetector:
    WINDOW    = 3     # seconds
    COOLDOWN  = 15    # seconds between alerts for the same IP
    THRESHOLD = 1000  # packets per window
    WHITELIST = WHITELIST_CACHE

    def __init__(self):
        self.stats = defaultdict(
            lambda: {'pkts': 0, 'start': time.time(), 'last_alert': 0}
        )
        self.lock = Lock()

    def detect(self, pkt):
        if not pkt.haslayer(IP):
            return

        src_ip = pkt[IP].src
        now    = time.time()

        if src_ip in self.WHITELIST:
            return

        with self.lock:
            s = self.stats[src_ip]
            if now - s['start'] > self.WINDOW:
                s['pkts']  = 0
                s['start'] = now

            s['pkts'] += 1

            if s['pkts'] < self.THRESHOLD:
                return
            if now - s['last_alert'] < self.COOLDOWN:
                return

            AlertManager.save('DDoS Attack', src_ip, {
                'packets_in_window': s['pkts'],
                'rate_per_second':   round(s['pkts'] / self.WINDOW),
                'description':       (
                    f"{src_ip} sent {s['pkts']} packets in {self.WINDOW}s."
                ),
                'action': (
                    'Block IP at the firewall or investigate the source device.'
                ),
            })
            s['last_alert'] = now


# ═══════════════════════════════════════════════════════════
#  PORT SCAN DETECTOR
# ═══════════════════════════════════════════════════════════
class PortScanDetector:
    THRESHOLD = 20  # unique ports
    WINDOW    = 10  # seconds
    COOLDOWN  = 30  # seconds between alerts for the same IP
    WHITELIST = WHITELIST_CACHE

    def __init__(self):
        self.tracker  = defaultdict(list)
        self.cooldown = {}
        self.lock     = Lock()

    def detect(self, pkt):
        if not pkt.haslayer(IP):
            return

        src_ip = pkt[IP].src
        now    = time.time()

        if src_ip in self.WHITELIST:
            return

        if pkt.haslayer(TCP):
            dst_port = pkt[TCP].dport
        elif pkt.haslayer(UDP):
            dst_port = pkt[UDP].dport
        else:
            return

        with self.lock:
            self.tracker[src_ip] = [
                (p, t) for p, t in self.tracker[src_ip]
                if now - t <= self.WINDOW
            ]
            self.tracker[src_ip].append((dst_port, now))
            unique_ports = {p for p, _ in self.tracker[src_ip]}

            if len(unique_ports) < self.THRESHOLD:
                return
            if now - self.cooldown.get(src_ip, 0) < self.COOLDOWN:
                return

            AlertManager.save('Port Scan', src_ip, {
                'unique_ports': len(unique_ports),
                'ports':        sorted(unique_ports),
                'description':  (
                    f"{src_ip} probed {len(unique_ports)} unique ports "
                    f"in {self.WINDOW}s."
                ),
                'action': (
                    'Monitor or block the source IP if activity is unexpected.'
                ),
            })
            self.cooldown[src_ip]  = now
            self.tracker[src_ip]   = []


# ═══════════════════════════════════════════════════════════
#  PACKET CAPTURE
# ═══════════════════════════════════════════════════════════
class PacketCapture:

    def __init__(self):
        self.arp_detector       = ArpSpoofDetector()
        self.ddos_detector      = DDoSDetector()
        self.port_scan_detector = PortScanDetector()

    def handle(self, pkt):
        try:
            self.arp_detector.detect(pkt)
            self.ddos_detector.detect(pkt)
            self.port_scan_detector.detect(pkt)
        except Exception as exc:
            print(f"[PACKET ERROR] {exc}")

    def start(self):
        while True:
            iface = InterfaceDetector.get_best_interface()
            try:
                print(f"[CAPTURE] Sniffing on interface: {iface}")
                sniff(iface=iface, prn=self.handle, store=False)
            except Exception as exc:
                print(f"[SNIFF ERROR] {exc} — restarting in 5 s")
                time.sleep(5)


# ═══════════════════════════════════════════════════════════
#  FLASK APP
# ═══════════════════════════════════════════════════════════
app = Flask(__name__)
app.secret_key = os.environ.get('FLASK_SECRET_KEY') or os.urandom(24)
app.config.update(
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE='Lax',
    # Set SESSION_COOKIE_SECURE=True when serving over HTTPS
)

print(f"[SELF-WHITELIST] Auto-detected own device IPs: {sorted(AUTO_OWN_IPS)}")
print(f"[WHITELIST] Active whitelist (auto + manual): {sorted(WHITELIST_CACHE)}")

capture = PacketCapture()


# ── Helpers ───────────────────────────────────────────────
def login_required(f):
    """Redirect unauthenticated requests to the login page."""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if 'admin' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return wrapper


def api_login_required(f):
    """Return 401 JSON for unauthenticated API requests."""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if 'admin' not in session:
            return jsonify({'error': 'unauthorized'}), 401
        return f(*args, **kwargs)
    return wrapper


# ── Auth ──────────────────────────────────────────────────
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        pw_hash  = hashlib.sha256(password.encode()).hexdigest()

        conn = Database.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                "SELECT * FROM admin WHERE username = %s AND password = %s",
                (username, pw_hash),
            )
            admin = cursor.fetchone()
        finally:
            cursor.close()
            conn.close()

        if admin:
            session.clear()
            session['admin']    = username
            session['admin_id'] = admin.get('id')
            AuditLogger.save(
                action='Login', status='success',
                username=username, user_id=admin.get('id'),
            )
            return redirect(url_for('dashboard'))

        AuditLogger.save(
            action='Login', status='failed',
            username=username or '(unknown)',
        )
        return render_template('login.html', error='Invalid username or password')

    return render_template('login.html')


@app.route('/logout')
def logout():
    AuditLogger.save(
        action='Logout', status='success',
        username=session.get('admin', ''),
        user_id=session.get('admin_id'),
    )
    session.clear()
    return redirect(url_for('login'))


# ── Pages ─────────────────────────────────────────────────
@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html', user=session['admin'])


@app.route('/alert')
@login_required
def alert():
    return render_template('alerts.html', user=session['admin'])


@app.route('/logs')
@login_required
def logs():
    return render_template('logs.html', user=session['admin'])


@app.route('/whitelist')
@login_required
def whitelist():
    return render_template('whitelist.html', user=session['admin'])


# ── Alert API ─────────────────────────────────────────────
@app.route('/api/alerts')
@api_login_required
def api_alerts():
    return jsonify({'alerts': AlertManager.get_all()})


@app.route('/api/whitelist')
@api_login_required
def api_whitelist():
    return jsonify({'entries': WhitelistManager.get_all()})


@app.route('/api/whitelist', methods=['POST'])
@api_login_required
def api_whitelist_add():
    data = request.get_json(silent=True) or {}
    ip_address = (data.get('ip_address') or '').strip()
    label = (data.get('label') or '').strip()

    if not ip_address:
        return jsonify({'success': False, 'message': 'IP address is required.'}), 400

    try:
        WhitelistManager.add(ip_address, label)
        refresh_whitelist()
        AuditLogger.save(
            action=f'Whitelist IP added: {ip_address}',
            username=session.get('admin', ''),
            user_id=session.get('admin_id'),
        )
        return jsonify({'success': True})
    except Exception as exc:
        return jsonify({'success': False, 'message': str(exc)}), 500


@app.route('/api/whitelist/<int:entry_id>', methods=['DELETE'])
@api_login_required
def api_whitelist_remove(entry_id):
    try:
        WhitelistManager.remove(entry_id)
        refresh_whitelist()
        AuditLogger.save(
            action=f'Whitelist entry removed (id={entry_id})',
            username=session.get('admin', ''),
            user_id=session.get('admin_id'),
        )
        return jsonify({'success': True})
    except Exception as exc:
        return jsonify({'success': False, 'message': str(exc)}), 500


# ── Logs API ──────────────────────────────────────────────
@app.route('/api/logs')
@api_login_required
def api_logs():
    try:
        per_page = int(request.args.get('per_page', 100))
        per_page = max(1, min(per_page, 1000))
    except (TypeError, ValueError):
        per_page = 100

    conn = Database.get_connection()
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            """SELECT id, user_id, username, action, ip_address, status, created_at
               FROM activity_logs
               ORDER BY created_at DESC
               LIMIT %s""",
            (per_page,),
        )
        rows = cursor.fetchall()
    finally:
        cursor.close()
        conn.close()

    for row in rows:
        row['created_at'] = str(row['created_at'])

    return jsonify({'logs': rows})


# ═══════════════════════════════════════════════════════════
#  ENTRY POINT  
# ═══════════════════════════════════════════════════════════
if __name__ == '__main__':
    threading.Thread(target=capture.start, daemon=True).start()
    app.run(debug=False)