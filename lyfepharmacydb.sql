-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
<<<<<<< HEAD
-- Generation Time: Sep 18, 2026 at 06:40 AM
=======
-- Generation Time: Sep 15, 2026 at 09:29 PM
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95
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
-- Database: `lyfepharmacydb`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action_type` text NOT NULL,
  `description` text NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`log_id`, `user_id`, `action_type`, `description`, `timestamp`) VALUES
(1, 1, 'Update', 'Updated Batch: B-101. New Stock: 35, Price: ₱13.', '2026-09-03 20:44:54'),
(2, 2, 'New Item', 'Registered new item: Ascorbic Acid (vit C) (generic) (Batch: B-103) with 1233 units.', '2026-09-03 21:40:43'),
(3, 2, 'Update', 'Updated Batch: B-103. New Stock: 1233, Price: ₱11.', '2026-09-03 21:40:49'),
(4, 2, 'New Item', 'Registered new item: Ascorbic Acid (Batch: B-103) with 122 units.', '2026-09-03 22:35:30'),
(5, 1, 'New Item', 'Registered new item: Sample 1 (Batch: 12345) with 123 units.', '2026-09-04 10:54:35'),
(6, 1, 'New Item', 'Registered new item: Sample 2 (Batch: b-123) with 43 units.', '2026-09-04 10:56:29'),
(7, 1, 'Update', 'Updated Batch: B-103. New Stock: 122, Price: ₱11.', '2026-09-04 14:41:42'),
(8, 2, 'Bulk Import', 'Imported 3 new items via CSV file.', '2026-09-04 15:47:16'),
(9, 2, 'Delete', 'Permanently deleted Batch: B-202.', '2026-09-04 15:48:17'),
(10, 2, 'Bulk Import', 'Imported 3 new items via CSV file.', '2026-09-04 15:54:15'),
(11, 2, 'Bulk Import', 'CSV Import processed. New items: 0. Existing batches updated: 3.', '2026-09-04 16:15:05'),
(12, 2, 'Delete', 'Permanently deleted Batch: B-203.', '2026-09-04 16:15:13'),
(13, 2, 'Bulk Import', 'CSV Import processed. New items: 0. Existing batches updated: 3.', '2026-09-04 16:15:19'),
(14, 2, 'Inventory Entry', 'Added 12 units to existing Batch: B-202 (Amoxicillin).', '2026-09-04 16:19:04'),
(15, 2, 'Delete', 'Permanently deleted Batch: B-103.', '2026-09-04 18:41:04'),
(16, 2, 'Smart Pricing', 'Mitigation applied: Reduced price of Sample 2 (Batch: b-123) from ₱22 to ₱18.7.', '2026-09-04 18:46:27'),
(17, 2, 'Smart Pricing', 'Mitigation applied: Reduced price of Sample 2 (Batch: b-123) from ₱18.7 to ₱6.73.', '2026-09-04 18:47:19'),
(18, 2, 'Smart Pricing', 'Mitigation applied: Reduced price of Sample 1 (Batch: 12345) from ₱42 to ₱21.', '2026-09-04 18:48:59'),
(19, 1, 'Delete', 'Permanently deleted Batch: 12345.', '2026-09-15 22:34:14'),
(20, 1, 'Bulk Import', 'CSV Import processed. New items: 8. Existing batches updated: 0.', '2026-09-15 22:51:25'),
(21, 1, 'Delete', 'Permanently deleted Batch: TXN-000008.', '2026-09-15 23:03:42'),
(22, 1, 'Delete', 'Permanently deleted Batch: TXN-000007.', '2026-09-15 23:03:45'),
(23, 1, 'Delete', 'Permanently deleted Batch: TXN-000006.', '2026-09-15 23:03:47'),
(24, 1, 'Delete', 'Permanently deleted Batch: TXN-000005.', '2026-09-15 23:03:50'),
(25, 1, 'Delete', 'Permanently deleted Batch: TXN-000001.', '2026-09-15 23:03:52'),
(26, 1, 'Delete', 'Permanently deleted Batch: TXN-000002.', '2026-09-15 23:03:54'),
(27, 1, 'Delete', 'Permanently deleted Batch: TXN-000003.', '2026-09-15 23:03:57'),
(28, 1, 'Delete', 'Permanently deleted Batch: TXN-000004.', '2026-09-15 23:03:59'),
<<<<<<< HEAD
(29, 2, 'POS Sale', 'Stock deducted for TXN-000001. Items: Sample 2 (Generic) (x6).', '2026-09-16 02:00:31'),
(30, 2, 'POS Sale', 'Stock deducted for TXN-000002. Items: Paracetamol (Biogesic) (x1), Paracetamol (Biogesic) (x1), Amoxicillin 500mg Cap (Generic) (x3).', '2026-09-16 23:37:27'),
(31, 2, 'POS Sale', 'Stock deducted for TXN-000003. Items: Salbutamol 2mg Tab (Generic) (x7), Ibuprofen 400mg Tab (Generic) (x2), Paracetamol (Biogesic) (x2).', '2026-09-16 23:37:31'),
(32, 2, 'POS Sale', 'Stock deducted for TXN-000004. Items: Paracetamol 500mg Tab (Generic) (x6), Paracetamol (Biogesic) (x1), Sample 2 (Generic) (x2), Ascorbic Acid (Generic) (x1).', '2026-09-16 23:37:37'),
(33, 2, 'POS Sale', 'Stock deducted for TXN-000005. Items: Ascorbic Acid (Generic) (x12), Amoxicillin (Generic) (x7), Paracetamol (Biogesic) (x2), Paracetamol (Biogesic) (x2).', '2026-09-16 23:37:45'),
(34, 1, 'Delete', 'Permanently deleted Batch: b-123.', '2026-09-17 00:29:05'),
(35, 1, 'Delete', 'Permanently deleted Batch: B-203.', '2026-09-17 00:29:10'),
(36, 1, 'Delete', 'Permanently deleted Batch: B-101.', '2026-09-17 00:29:14'),
(37, 1, 'Inventory Entry', 'Registered new item: Smaple (Generic) (Batch: B-200) with 123 units.', '2026-09-17 00:40:57'),
(38, 2, 'Delete', 'Permanently deleted Batch: B-202.', '2026-09-17 01:03:50'),
(39, 2, 'POS Sale', 'Stock deducted for TXN-001014. Items: Salbutamol 2mg Tab (Generic) (x8).', '2026-09-17 18:32:09');
=======
(29, 2, 'POS Sale', 'Stock deducted for TXN-000001. Items: Sample 2 (Generic) (x6).', '2026-09-16 02:00:31');
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

-- --------------------------------------------------------

--
-- Table structure for table `inventory_batches`
--

CREATE TABLE `inventory_batches` (
  `batch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `batch_number` text NOT NULL,
  `expiry_date` date NOT NULL,
  `quantity_in_stock` int(11) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `smart_pricing_status` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_batches`
--

INSERT INTO `inventory_batches` (`batch_id`, `product_id`, `batch_number`, `expiry_date`, `quantity_in_stock`, `selling_price`, `smart_pricing_status`) VALUES
<<<<<<< HEAD
(2, 2, 'B-102', '2027-11-20', 9, 5.00, 'Inactive'),
(4, 4, 'B-104', '2028-01-12', 198, 9.00, 'Inactive'),
(7, 7, 'B-107', '2028-11-05', 285, 5.00, 'Inactive'),
(9, 12, 'B-103', '2026-09-14', 99, 11.00, 'Inactive'),
(12, 15, 'B-201', '2027-11-03', 1493, 5.50, 'Inactive'),
(15, 18, 'B-201', '2027-11-03', 1494, 5.50, 'Inactive'),
(26, 29, 'B-200', '2026-09-21', 123, 45.00, 'Inactive');
=======
(1, 1, 'B-101', '2027-05-10', 35, 13.00, 'Inactive'),
(2, 2, 'B-102', '2027-11-20', 15, 5.00, 'Inactive'),
(4, 4, 'B-104', '2028-01-12', 200, 9.00, 'Inactive'),
(7, 7, 'B-107', '2028-11-05', 300, 5.00, 'Inactive'),
(9, 12, 'B-103', '2026-09-14', 112, 11.00, 'Inactive'),
(11, 14, 'b-123', '2026-10-10', 37, 6.73, 'Active'),
(12, 15, 'B-201', '2027-11-03', 1498, 5.50, 'Inactive'),
(15, 18, 'B-201', '2027-11-03', 1498, 5.50, 'Inactive'),
(16, 19, 'B-202', '2026-05-03', 912, 8.00, 'Inactive'),
(17, 20, 'B-203', '2026-03-20', 3000, 4.25, 'Inactive');
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `barcode` text NOT NULL,
  `generic_name` text NOT NULL,
  `brand_name` text NOT NULL,
  `category` text NOT NULL,
  `reorder_level` int(11) NOT NULL,
  `drug_type` varchar(10) DEFAULT 'OTC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `barcode`, `generic_name`, `brand_name`, `category`, `reorder_level`, `drug_type`) VALUES
(2, 'BAR-102', 'Paracetamol 500mg Tab', 'Generic', 'Analgesic', 50, 'OTC'),
(3, 'BAR-103', 'Ascorbic Acid (Vit C)', 'Generic', 'Vitamins', 50, 'Rx'),
(4, 'BAR-104', 'Ibuprofen 400mg Tab', 'Generic', 'NSAID', 50, 'OTC'),
(5, 'BAR-105', 'Cetirizine 10mg Tab', 'Generic', 'Antihistamine', 50, 'OTC'),
(7, 'BAR-107', 'Salbutamol 2mg Tab', 'Generic', 'Bronchodilator', 50, 'OTC'),
(8, 'BAR-108', 'Losartan 50mg Tab', 'Generic', 'Antihypertensive', 50, 'OTC'),
(10, 'BAR-110', 'Mefenamic Acid 500mg', 'Generic', 'NSAID', 50, 'OTC'),
(12, 'BAR-47570', 'Ascorbic Acid', 'Generic', 'Uncategorized', 50, 'OTC'),
<<<<<<< HEAD
=======
(14, 'BAR-37881', 'Sample 2', 'Generic', 'Uncategorized', 50, 'OTC'),
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95
(15, 'BAR-58048', 'Paracetamol', 'Biogesic', 'Analgesic', 50, 'OTC'),
(18, 'BAR-42006', 'Paracetamol', 'Biogesic', 'Analgesic', 50, 'OTC'),
(29, 'BAR-25146', 'Smaple', 'Generic', 'Samplecategory', 50, 'OTC');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(1, 'Owner'),
(2, 'Employee');

-- --------------------------------------------------------

--
-- Table structure for table `sales_items`
--

CREATE TABLE `sales_items` (
  `sales_item_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `quantity_sold` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_items`
--

INSERT INTO `sales_items` (`sales_item_id`, `transaction_id`, `batch_id`, `quantity_sold`, `subtotal`) VALUES
<<<<<<< HEAD
(2, 2, 15, 1, 5.50),
(3, 2, 12, 1, 5.50),
(5, 3, 7, 7, 35.00),
(6, 3, 4, 2, 18.00),
(7, 3, 12, 2, 11.00),
(8, 4, 2, 6, 30.00),
(9, 4, 15, 1, 5.50),
(11, 4, 9, 1, 11.00),
(12, 5, 9, 12, 132.00),
(14, 5, 12, 2, 11.00),
(15, 5, 15, 2, 11.00),
(16, 1002, 2, 100, 500.00),
(17, 1002, 4, 100, 900.00),
(18, 1003, 7, 200, 1000.00),
(19, 1003, 9, 100, 1100.00),
(21, 1004, 2, 300, 1500.00),
(23, 1005, 4, 200, 1800.00),
(24, 1006, 9, 200, 2200.00),
(26, 1007, 2, 300, 1500.00),
(28, 1008, 7, 500, 2500.00),
(29, 1008, 4, 300, 2700.00),
(30, 1014, 7, 8, 40.00);
=======
(1, 1, 11, 6, 40.38);
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

-- --------------------------------------------------------

--
-- Table structure for table `sales_transactions`
--

CREATE TABLE `sales_transactions` (
  `transaction_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `transaction_date` datetime NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `total_qty` int(11) NOT NULL DEFAULT 0,
  `payment_method` text NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `prc_license` varchar(50) DEFAULT NULL,
  `ptr_number` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_transactions`
--

INSERT INTO `sales_transactions` (`transaction_id`, `user_id`, `transaction_date`, `total_amount`, `total_qty`, `payment_method`, `customer_name`, `prc_license`, `ptr_number`) VALUES
<<<<<<< HEAD
(1, 2, '2026-09-16 02:00:31', 40.38, 6, 'Cash', '', '', ''),
(2, 2, '2026-09-16 23:37:27', 50.00, 5, 'Cash', '', '', ''),
(3, 2, '2026-09-16 23:37:31', 64.00, 11, 'Cash', '', '', ''),
(4, 2, '2026-09-16 23:37:37', 59.96, 10, 'Cash', '', '', ''),
(5, 2, '2026-09-16 23:37:45', 210.00, 23, 'Cash', '', '', ''),
(1002, 2, '2026-04-15 10:30:00', 1400.00, 200, 'Cash', '', '', ''),
(1003, 2, '2026-05-10 14:45:00', 2100.00, 300, 'GCash', '', '', ''),
(1004, 2, '2026-06-14 09:15:00', 2700.00, 450, 'Cash', '', '', ''),
(1005, 2, '2026-07-05 16:20:00', 3500.00, 600, 'Cash', '', '', ''),
(1006, 2, '2026-08-08 11:10:00', 4150.00, 350, 'GCash', '', '', ''),
(1007, 2, '2026-09-02 13:05:00', 2350.00, 500, 'Cash', '', '', ''),
(1008, 2, '2026-09-14 15:50:00', 5200.00, 800, 'GCash', '', '', ''),
(1009, 2, '2026-04-15 10:30:00', 1400.00, 200, 'Cash', '', '', ''),
(1010, 2, '2026-05-10 14:45:00', 2100.00, 300, 'GCash', '', '', ''),
(1011, 2, '2026-06-14 09:15:00', 2700.00, 450, 'Cash', '', '', ''),
(1012, 2, '2026-07-05 16:20:00', 3500.00, 600, 'Cash', '', '', ''),
(1013, 2, '2026-08-08 11:10:00', 4150.00, 350, 'GCash', '', '', ''),
(1014, 2, '2026-09-17 18:32:08', 40.00, 8, 'Cash', '', '', '');
=======
(1, 2, '2026-09-16 02:00:31', 40.38, 6, 'Cash', '', '', '');
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `first_name` text NOT NULL,
  `middle_initial` varchar(5) NOT NULL,
  `last_name` text NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `email` text NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `status` text NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `last_active` datetime DEFAULT NULL,
  `sms_alerts_enabled` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `first_name`, `middle_initial`, `last_name`, `phone_number`, `email`, `username`, `password`, `status`, `last_login`, `last_active`, `sms_alerts_enabled`) VALUES
<<<<<<< HEAD
(1, 1, 'John Kaye', '', 'Fernandez', '09936178148', 'admin', 'johnkaye123', '123', 'Offline', '2026-09-17 18:56:32', '2026-09-17 19:15:12', 1),
(2, 2, 'Joseph', '', 'Osena', '09936178148', 'joseph_staff', 'osep123', '123', 'Offline', '2026-09-17 19:15:39', '2026-09-18 00:48:17', 0),
=======
(1, 1, 'John Kaye', '', 'Fernandez', '12345678990', 'admin', 'johnkaye123', '123', 'Offline', '2026-09-16 03:21:43', '2026-09-16 03:26:14', 1),
(2, 2, 'Joseph', '', 'Osena', '09936178148', 'joseph_staff', 'osep123', '123', 'Offline', '2026-09-16 02:01:38', '2026-09-16 02:01:38', 1),
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95
(3, 2, 'Francis', '', 'Mariscal', '', 'francis_staff', 'francis123', 'lyfe2026', 'Offline', NULL, NULL, 1),
(5, 2, 'quaso', 'D', 'bread', '09123456798', 'name@gmail.com', 'quaso', '123', 'Offline', NULL, NULL, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
  ADD PRIMARY KEY (`batch_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `sales_items`
--
ALTER TABLE `sales_items`
  ADD PRIMARY KEY (`sales_item_id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `batch_id` (`batch_id`);

--
-- Indexes for table `sales_transactions`
--
ALTER TABLE `sales_transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
<<<<<<< HEAD
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;
=======
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

--
-- AUTO_INCREMENT for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
<<<<<<< HEAD
  MODIFY `batch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
=======
  MODIFY `batch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
<<<<<<< HEAD
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
=======
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sales_items`
--
ALTER TABLE `sales_items`
<<<<<<< HEAD
  MODIFY `sales_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
=======
  MODIFY `sales_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

--
-- AUTO_INCREMENT for table `sales_transactions`
--
ALTER TABLE `sales_transactions`
<<<<<<< HEAD
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1015;
=======
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
>>>>>>> ad70bc0eee088ebcb0a38e0044fe7885ccfc8f95

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
  ADD CONSTRAINT `inventory_batches_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `sales_items`
--
ALTER TABLE `sales_items`
  ADD CONSTRAINT `sales_items_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `sales_transactions` (`transaction_id`),
  ADD CONSTRAINT `sales_items_ibfk_2` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`batch_id`);

--
-- Constraints for table `sales_transactions`
--
ALTER TABLE `sales_transactions`
  ADD CONSTRAINT `sales_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
