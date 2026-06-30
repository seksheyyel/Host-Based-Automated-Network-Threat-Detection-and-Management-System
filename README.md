# Host-Based Automated Network Threat Detection and Management System (ThreatMon)

## About the Project

ThreatMon is a **Host-Based Intrusion Detection System (HIDS)** developed using **Python, Flask, Scapy, and MySQL**. It automatically monitors the network traffic of the computer where it is installed and detects common network threats such as:

- ARP Spoofing
- DDoS Attacks
- Port Scanning

When a threat is detected, the system automatically records the event in the database and displays an alert through a web-based dashboard.

Since ThreatMon is a **Host-Based IDS**, it protects only the device where it is installed. To protect multiple devices, the application should be installed on each computer.

---

## Purpose

The purpose of this project is to provide an automated host-based network security solution that monitors network traffic in real time, detects common network threats, and helps administrators monitor the security of the protected device through a web-based dashboard.

---

## Features

- User Login Authentication
- Real-Time Packet Monitoring
- ARP Spoofing Detection
- DDoS Detection
- Port Scan Detection
- Alert Logging
- IP Whitelist Management
- Audit Logs
- Flask Web Dashboard
- MySQL Database

---

## Technologies Used

- Python
- Flask
- Scapy
- MySQL
- HTML
- CSS
- JavaScript
- Bootstrap

---

## How to Run

1. Install Python 3.
2. Install the required packages.

```bash
pip install -r requirements.txt
```

3. Import the provided SQL database.
4. Configure the database connection in `app.py`.
5. Run the application.

```bash
python app.py
```

6. Open your browser and go to:

```
http://localhost:5000
```

---

## Developers

- Ryan Macapayag
- Derek Angelo Manzo
- John Reuben Bautista
- Jhon Paulo Genandoy
- Angelo Calubihan
