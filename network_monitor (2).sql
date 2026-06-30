-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 30, 2026 at 06:36 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `network_monitor`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(100) NOT NULL DEFAULT '',
  `action` varchar(120) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `status` enum('success','warning','failed') NOT NULL DEFAULT 'success',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `username`, `action`, `ip_address`, `status`, `created_at`) VALUES
(1, 1, 'admin', 'Login', '192.168.1.10', 'success', '2026-05-10 21:29:24'),
(2, 1, 'admin', 'Delete Alert', '192.168.1.10', 'warning', '2026-05-10 21:30:24'),
(3, 1, 'admin', 'Delete All Alerts', '192.168.1.10', 'warning', '2026-05-10 21:31:24'),
(4, 1, 'admin', 'Logout', '192.168.1.10', 'success', '2026-05-10 21:32:24'),
(5, NULL, 'hacker', 'Login', '203.0.113.99', 'failed', '2026-05-10 21:33:24'),
(6, NULL, 'root', 'Login', '198.51.100.42', 'failed', '2026-05-10 21:34:24'),
(7, NULL, 'admin', 'Delete All Alerts', '127.0.0.1', 'warning', '2026-05-10 21:36:53'),
(8, NULL, 'admin', 'Logout', '127.0.0.1', 'success', '2026-05-10 21:44:16'),
(9, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-05-10 21:44:21'),
(10, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-05-10 21:44:24'),
(11, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-10 21:44:28'),
(12, 1, 'admin', 'Delete Alert', '127.0.0.1', 'warning', '2026-05-10 21:47:03'),
(13, 1, 'admin', 'Delete All Alerts', '127.0.0.1', 'warning', '2026-05-10 21:47:16'),
(14, 1, 'admin', 'Logout', '127.0.0.1', 'success', '2026-05-10 21:48:33'),
(15, 2, 'bautista', 'Login', '127.0.0.1', 'success', '2026-05-10 21:48:40'),
(16, 2, 'bautista', 'Delete All Alerts', '127.0.0.1', 'warning', '2026-05-10 21:49:58'),
(17, NULL, 'bautista', 'Login', '127.0.0.1', 'failed', '2026-05-14 22:24:04'),
(18, NULL, 'bautista', 'Login', '127.0.0.1', 'failed', '2026-05-14 22:24:13'),
(19, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-14 22:24:18'),
(20, 1, 'admin', 'Delete All Alerts', '127.0.0.1', 'warning', '2026-05-14 22:25:58'),
(21, 1, 'admin', 'Update ARP Thresholds', '127.0.0.1', 'success', '2026-05-14 22:59:45'),
(22, 1, 'admin', 'Update ARP Thresholds', '127.0.0.1', 'success', '2026-05-14 22:59:55'),
(23, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-05-14 23:00:16'),
(24, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-14 23:09:02'),
(25, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-05-14 23:09:18'),
(26, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-05-14 23:10:38'),
(27, 1, 'admin', 'Logout', '127.0.0.1', 'success', '2026-05-14 23:31:54'),
(28, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-05-14 23:31:58'),
(29, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-05-14 23:32:00'),
(30, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-14 23:32:03'),
(31, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-05-14 23:32:19'),
(32, 1, 'admin', 'Logout', '127.0.0.1', 'success', '2026-05-14 23:32:23'),
(33, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-14 23:32:26'),
(34, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-14 23:34:00'),
(35, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-20 22:03:25'),
(36, NULL, 'admin1', 'Login', '127.0.0.1', 'failed', '2026-05-20 22:11:02'),
(37, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-20 22:11:06'),
(38, 1, 'admin', 'Logout', '127.0.0.1', 'success', '2026-05-20 22:18:31'),
(39, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-20 22:18:46'),
(40, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-20 22:20:47'),
(41, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-05-20 22:33:34'),
(42, 1, 'admin', 'Delete All Alerts', '127.0.0.1', 'warning', '2026-05-20 22:33:47'),
(43, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-05-20 22:46:27'),
(44, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-09 20:06:32'),
(45, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-06-09 20:38:34'),
(46, 1, 'admin', 'Update ARP Thresholds', '127.0.0.1', 'success', '2026-06-09 20:38:45'),
(47, 1, 'admin', 'Update PORTSCAN Thresholds', '127.0.0.1', 'success', '2026-06-09 20:38:55'),
(48, 1, 'admin', 'Update DDOS Thresholds', '127.0.0.1', 'success', '2026-06-09 20:39:08'),
(49, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-14 22:10:23'),
(50, 1, 'admin', 'Delete All Alerts', '127.0.0.1', 'warning', '2026-06-14 22:30:14'),
(51, 1, 'admin', 'Logout', '127.0.0.1', 'success', '2026-06-14 22:44:13'),
(52, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-14 22:44:18'),
(53, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-17 21:22:55'),
(54, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-20 11:32:31'),
(55, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-20 12:04:58'),
(56, 1, 'admin', 'Ran network scan (0 devices found)', '127.0.0.1', 'success', '2026-06-20 12:05:11'),
(57, 1, 'admin', 'Ran network scan (0 devices found)', '127.0.0.1', 'success', '2026-06-20 12:06:25'),
(58, 1, 'admin', 'Ran network scan (0 devices found)', '127.0.0.1', 'success', '2026-06-20 12:06:29'),
(59, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-20 12:07:49'),
(60, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-22 18:57:20'),
(61, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-22 19:25:36'),
(62, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-22 19:27:56'),
(63, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:18:17'),
(64, 1, 'admin', 'Logout', '127.0.0.1', 'success', '2026-06-30 10:22:26'),
(65, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:22:32'),
(66, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:26:45'),
(67, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:39:02'),
(68, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:43:56'),
(69, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:56:44'),
(70, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 10:58:27'),
(71, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-06-30 11:01:26'),
(72, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-06-30 11:01:30'),
(73, NULL, 'admin', 'Login', '127.0.0.1', 'failed', '2026-06-30 11:01:34'),
(74, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:01:46'),
(75, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:06:04'),
(76, 1, 'admin', 'Whitelist IP added: 192.168.100.31', '127.0.0.1', 'success', '2026-06-30 11:07:15'),
(77, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:09:50'),
(78, 1, 'admin', 'Whitelist entry removed (id=1)', '127.0.0.1', 'success', '2026-06-30 11:13:18'),
(79, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:14:28'),
(80, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:17:28'),
(81, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:19:33'),
(82, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:20:18'),
(83, 1, 'admin', 'Whitelist IP added: 192.168.100.31', '127.0.0.1', 'success', '2026-06-30 11:27:11'),
(84, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:27:57'),
(85, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:44:49'),
(86, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:45:29'),
(87, 1, 'admin', 'Login', '127.0.0.1', 'success', '2026-06-30 11:45:54');

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`, `password_hash`) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'scrypt:32768:8:1$ZQlmK5HwOcUTYr9F$ae73f28fc17f4120d095f8d75f4a21e57ba1be4c70ce005cd207aacfbd0edaa0c964f214f5c6a00d90deb626061940811c4ac0d001991650d43a3a49c24ff2d1'),
(2, 'bautista', '41e5653fc7aeb894026d6bb7b2db7f65902b454945fa8fd65a6327047b5277fb', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `network_alerts`
--

CREATE TABLE `network_alerts` (
  `id` int(11) NOT NULL,
  `alert_type` varchar(50) NOT NULL,
  `source_ip` varchar(45) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`details`)),
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `network_alerts`
--

INSERT INTO `network_alerts` (`id`, `alert_type`, `source_ip`, `details`, `timestamp`) VALUES
(301, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 25, \"ports\": [50253, 50529, 51413, 51559, 51784, 52439, 52961, 53883, 54092, 55944, 57927, 58395, 59614, 59974, 60419, 61402, 61498, 62271, 62584, 62638, 62918, 62947, 63656, 63828, 65151], \"description\": \"192.168.100.1 probed 25 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:36:46'),
(302, 'Port Scan', '192.168.100.31', '{\"unique_ports\": 20, \"ports\": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 53, 443], \"description\": \"192.168.100.31 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:36:54'),
(303, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [49206, 50181, 50383, 50785, 50863, 50916, 51777, 51809, 52060, 52296, 54634, 56948, 58236, 59736, 61660, 62124, 62638, 62873, 63970, 64137], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:37:17'),
(304, 'Port Scan', '51.104.15.252', '{\"unique_ports\": 20, \"ports\": [57528, 57529, 57530, 57531, 57532, 57533, 57534, 57535, 57537, 57538, 57539, 64155, 64156, 64157, 64158, 64159, 64160, 64161, 64163, 64164], \"description\": \"51.104.15.252 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:39:22'),
(305, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [50607, 52964, 53168, 53600, 54407, 54493, 54750, 55678, 55758, 55811, 58459, 58967, 59147, 59542, 60562, 60593, 60913, 62254, 63056, 64253], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:39:53'),
(306, 'Port Scan', '20.42.73.28', '{\"unique_ports\": 20, \"ports\": [49672, 49674, 49675, 49676, 49679, 49680, 49681, 49682, 54769, 62432, 62433, 62434, 62435, 62436, 62437, 62438, 62439, 62440, 62441, 62442], \"description\": \"20.42.73.28 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:40:11'),
(307, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [51535, 51983, 52067, 52325, 52984, 53883, 53993, 55369, 55804, 56153, 57526, 59824, 60107, 61174, 61795, 62704, 64303, 64695, 65116, 65460], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:40:24'),
(308, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [1900, 49210, 51535, 52067, 52325, 55369, 56153, 56201, 56466, 58942, 59824, 59991, 60174, 61795, 64234, 64303, 64695, 65056, 65116, 65460], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:41:09'),
(309, 'Port Scan', '104.46.162.231', '{\"unique_ports\": 20, \"ports\": [56808, 56810, 56811, 56812, 56813, 56814, 56815, 56816, 56817, 61069, 61070, 61071, 61072, 61073, 61074, 61075, 61076, 61077, 61078, 61079], \"description\": \"104.46.162.231 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:41:14'),
(310, 'Port Scan', '20.184.175.20', '{\"unique_ports\": 20, \"ports\": [53830, 53831, 53832, 53833, 53834, 53835, 53836, 53837, 53838, 53839, 53840, 53841, 53842, 53843, 53844, 53846, 53847, 53848, 53850, 53851], \"description\": \"20.184.175.20 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:41:19'),
(311, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [49680, 49814, 51044, 51955, 51991, 53290, 53435, 54061, 54105, 54477, 55426, 55675, 56466, 57014, 57230, 58774, 62753, 62868, 63458, 64017], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 10:43:49'),
(312, 'ARP Spoofing', '192.168.1.1', '{\"trusted_mac\": \"aa:bb:cc:dd:ee:ff\", \"attacker_macs\": [\"11:22:33:44:55:66\"], \"description\": \"IP 192.168.1.1 claimed 2 different MACs within 30s.\", \"action\": \"Verify devices on the network. Enable Dynamic ARP Inspection if possible.\"}', '2026-06-30 10:44:16'),
(313, 'Port Scan', '20.42.65.90', '{\"unique_ports\": 20, \"ports\": [63807, 63808, 63809, 63810, 63811, 63812, 63813, 63814, 63815, 63816, 63817, 63818, 63820, 63821, 63822, 63823, 63824, 63825, 63826, 63830], \"description\": \"20.42.65.90 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:05:48'),
(314, 'DDoS Attack', '23.49.104.57', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"23.49.104.57 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 11:08:11'),
(315, 'Port Scan', '20.184.175.0', '{\"unique_ports\": 20, \"ports\": [55339, 55343, 55344, 55345, 62779, 62780, 62781, 62782, 62783, 62784, 62785, 62786, 62787, 62788, 62789, 62790, 62791, 62793, 64067, 64069], \"description\": \"20.184.175.0 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:08:55'),
(316, 'DDoS Attack', '136.158.108.8', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"136.158.108.8 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 11:10:57'),
(317, 'Port Scan', '20.184.175.21', '{\"unique_ports\": 20, \"ports\": [52375, 52376, 52377, 52378, 52379, 52380, 52381, 52382, 52383, 52384, 52385, 63220, 63221, 63222, 63223, 63224, 63225, 63226, 63228, 64018], \"description\": \"20.184.175.21 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:21:08'),
(318, 'Port Scan', '20.42.73.28', '{\"unique_ports\": 20, \"ports\": [58404, 58405, 58406, 58407, 58408, 58409, 58410, 58411, 58412, 58413, 58414, 58415, 58416, 58417, 58418, 58419, 58420, 58421, 58422, 58423], \"description\": \"20.42.73.28 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:21:14'),
(319, 'Port Scan', '13.89.179.10', '{\"unique_ports\": 20, \"ports\": [51286, 51287, 51288, 51289, 51290, 51291, 51292, 51293, 51294, 51295, 51297, 51299, 51300, 51301, 51302, 51303, 51306, 51307, 51308, 51309], \"description\": \"13.89.179.10 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:23:16'),
(320, 'ARP Spoofing', '192.168.1.1', '{\"trusted_mac\": \"11:22:33:44:55:66\", \"attacker_macs\": [\"aa:bb:cc:dd:ee:ff\", \"77:88:99:aa:bb:cc\"], \"description\": \"IP 192.168.1.1 claimed 3 different MACs within 30s.\", \"action\": \"Verify devices on the network. Enable Dynamic ARP Inspection if possible.\"}', '2026-06-30 11:24:24'),
(321, 'ARP Spoofing', '192.168.1.1', '{\"trusted_mac\": \"11:22:33:44:55:66\", \"attacker_macs\": [\"aa:bb:cc:dd:ee:ff\", \"77:88:99:aa:bb:cc\"], \"description\": \"IP 192.168.1.1 claimed 3 different MACs within 30s.\", \"action\": \"Verify devices on the network. Enable Dynamic ARP Inspection if possible.\"}', '2026-06-30 11:26:31'),
(322, 'ARP Spoofing', '192.168.1.1', '{\"trusted_mac\": \"11:22:33:44:55:66\", \"attacker_macs\": [\"aa:bb:cc:dd:ee:ff\", \"77:88:99:aa:bb:cc\"], \"description\": \"IP 192.168.1.1 claimed 3 different MACs within 30s.\", \"action\": \"Verify devices on the network. Enable Dynamic ARP Inspection if possible.\"}', '2026-06-30 11:27:23'),
(323, 'ARP Spoofing', '192.168.1.1', '{\"trusted_mac\": \"11:22:33:44:55:66\", \"attacker_macs\": [\"77:88:99:aa:bb:cc\", \"aa:bb:cc:dd:ee:ff\"], \"description\": \"IP 192.168.1.1 claimed 3 different MACs within 30s.\", \"action\": \"Verify devices on the network. Enable Dynamic ARP Inspection if possible.\"}', '2026-06-30 11:28:10'),
(324, 'Port Scan', '20.44.10.123', '{\"unique_ports\": 20, \"ports\": [51693, 51694, 51695, 51696, 51697, 51698, 61828, 61829, 61830, 61831, 61834, 61835, 61836, 61837, 61838, 61839, 61840, 61841, 61842, 61844], \"description\": \"20.44.10.123 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:31:03'),
(325, 'DDoS Attack', '136.158.108.147', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"136.158.108.147 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 11:38:13'),
(326, 'Port Scan', '192.168.100.31', '{\"unique_ports\": 20, \"ports\": [53, 443, 500, 8509, 8520, 8523, 8532, 8533, 8555, 8556, 8595, 8597, 8599, 8601, 8602, 8626, 8636, 8650, 8744, 8753], \"description\": \"192.168.100.31 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:44:41'),
(327, 'Port Scan', '192.168.100.31', '{\"unique_ports\": 20, \"ports\": [53, 443, 5222, 8504, 8509, 8512, 8535, 8540, 8555, 8556, 8592, 8597, 8599, 8600, 8603, 8620, 8621, 8623, 8626, 8668], \"description\": \"192.168.100.31 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:45:24'),
(328, 'Port Scan', '16.145.202.251', '{\"unique_ports\": 20, \"ports\": [61772, 61773, 61774, 61775, 61776, 61777, 61778, 61779, 61780, 61781, 61782, 61783, 61784, 61785, 61786, 61787, 61788, 61789, 61793, 61795], \"description\": \"16.145.202.251 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:49:39'),
(329, 'DDoS Attack', '173.194.51.37', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"173.194.51.37 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 11:50:07'),
(330, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [49674, 50275, 50381, 53422, 53534, 57493, 57734, 57936, 58366, 58742, 59071, 59993, 60504, 60675, 63310, 63312, 63320, 63510, 63817, 64712], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:51:00'),
(331, 'DDoS Attack', '160.79.104.10', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"160.79.104.10 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 11:51:22'),
(332, 'DDoS Attack', '160.79.104.10', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"160.79.104.10 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 11:51:58'),
(333, 'Port Scan', '192.168.100.1', '{\"unique_ports\": 20, \"ports\": [51679, 52231, 52581, 55515, 56394, 57030, 58674, 58723, 58791, 59445, 59859, 60198, 60396, 63315, 63805, 63970, 64230, 64531, 65040, 65250], \"description\": \"192.168.100.1 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 11:52:01'),
(334, 'Port Scan', '20.184.175.19', '{\"unique_ports\": 20, \"ports\": [56199, 56200, 56201, 56202, 56203, 56204, 56205, 56206, 56207, 56208, 56209, 56210, 56212, 56214, 62328, 62329, 62330, 62331, 62332, 62333], \"description\": \"20.184.175.19 probed 20 unique ports in 10s.\", \"action\": \"Monitor or block the source IP if activity is unexpected.\"}', '2026-06-30 12:15:43'),
(335, 'ARP Spoofing', '192.168.1.1', '{\"trusted_mac\": \"11:22:33:44:55:66\", \"attacker_macs\": [\"77:88:99:aa:bb:cc\", \"aa:bb:cc:dd:ee:ff\"], \"description\": \"IP 192.168.1.1 claimed 3 different MACs within 30s.\", \"action\": \"Verify devices on the network. Enable Dynamic ARP Inspection if possible.\"}', '2026-06-30 12:16:36'),
(336, 'DDoS Attack', '136.158.108.82', '{\"packets_in_window\": 1000, \"rate_per_second\": 333, \"description\": \"136.158.108.82 sent 1000 packets in 3s.\", \"action\": \"Block IP at the firewall or investigate the source device.\"}', '2026-06-30 12:29:19');

-- --------------------------------------------------------

--
-- Table structure for table `whitelist_ips`
--

CREATE TABLE `whitelist_ips` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `label` varchar(100) DEFAULT '',
  `added_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `whitelist_ips`
--

INSERT INTO `whitelist_ips` (`id`, `ip_address`, `label`, `added_at`) VALUES
(2, '192.168.100.31', 'My device', '2026-06-30 11:27:11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `network_alerts`
--
ALTER TABLE `network_alerts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `whitelist_ips`
--
ALTER TABLE `whitelist_ips`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip_address` (`ip_address`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `network_alerts`
--
ALTER TABLE `network_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=337;

--
-- AUTO_INCREMENT for table `whitelist_ips`
--
ALTER TABLE `whitelist_ips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
