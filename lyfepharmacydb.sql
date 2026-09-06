-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 06, 2026 at 02:01 PM
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
(18, 2, 'Smart Pricing', 'Mitigation applied: Reduced price of Sample 1 (Batch: 12345) from ₱42 to ₱21.', '2026-09-04 18:48:59');

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
(1, 1, 'B-101', '2027-05-10', 35, 13.00, 'Inactive'),
(2, 2, 'B-102', '2027-11-20', 15, 5.00, 'Inactive'),
(4, 4, 'B-104', '2028-01-12', 200, 9.00, 'Inactive'),
(7, 7, 'B-107', '2028-11-05', 300, 5.00, 'Inactive'),
(9, 12, 'B-103', '2026-09-14', 112, 11.00, 'Inactive'),
(10, 13, '12345', '2026-09-14', 108, 21.00, 'Active'),
(11, 14, 'b-123', '2026-10-10', 43, 6.73, 'Active'),
(12, 15, 'B-201', '2027-11-03', 1498, 5.50, 'Inactive'),
(15, 18, 'B-201', '2027-11-03', 1498, 5.50, 'Inactive'),
(16, 19, 'B-202', '2026-05-03', 912, 8.00, 'Inactive'),
(17, 20, 'B-203', '2026-03-20', 3000, 4.25, 'Inactive');

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
(1, 'BAR-101', 'Amoxicillin 500mg Cap', 'Generic', 'Antibiotic', 50, 'OTC'),
(2, 'BAR-102', 'Paracetamol 500mg Tab', 'Generic', 'Analgesic', 50, 'OTC'),
(3, 'BAR-103', 'Ascorbic Acid (Vit C)', 'Generic', 'Vitamins', 50, 'Rx'),
(4, 'BAR-104', 'Ibuprofen 400mg Tab', 'Generic', 'NSAID', 50, 'OTC'),
(5, 'BAR-105', 'Cetirizine 10mg Tab', 'Generic', 'Antihistamine', 50, 'OTC'),
(7, 'BAR-107', 'Salbutamol 2mg Tab', 'Generic', 'Bronchodilator', 50, 'OTC'),
(8, 'BAR-108', 'Losartan 50mg Tab', 'Generic', 'Antihypertensive', 50, 'OTC'),
(10, 'BAR-110', 'Mefenamic Acid 500mg', 'Generic', 'NSAID', 50, 'OTC'),
(12, 'BAR-47570', 'Ascorbic Acid', 'Generic', 'Uncategorized', 50, 'OTC'),
(13, 'BAR-31928', 'Sample 1', 'Generic', 'Uncategorized', 50, 'Rx'),
(14, 'BAR-37881', 'Sample 2', 'Generic', 'Uncategorized', 50, 'OTC'),
(15, 'BAR-58048', 'Paracetamol', 'Biogesic', 'Analgesic', 50, 'OTC'),
(18, 'BAR-42006', 'Paracetamol', 'Biogesic', 'Analgesic', 50, 'OTC'),
(19, 'BAR-23679', 'Amoxicillin', 'Generic', 'Antibiotic', 50, 'OTC'),
(20, 'BAR-93328', 'Ascorbic Acid', 'Poten-cee', 'Vitamins', 50, 'OTC');

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
(1, 1, 2, 1, 5.00),
(5, 3, 1, 1, 13.00),
(8, 4, 7, 1, 5.00),
(9, 5, 10, 13, 273.00),
(10, 6, 9, 10, 110.00),
(11, 7, 15, 2, 11.00),
(12, 7, 12, 2, 11.00),
(13, 8, 10, 2, 42.00);

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
(1, 2, '2026-07-15 00:00:00', 20.00, 0, 'Cash', NULL, NULL, NULL),
(2, 3, '2026-07-15 00:00:00', 172.00, 0, 'Cash', NULL, NULL, NULL),
(3, 2, '2026-07-15 00:00:00', 13.00, 0, 'Cash', NULL, NULL, NULL),
(4, 3, '2026-07-15 00:00:00', 22.00, 0, 'Cash', NULL, NULL, NULL),
(5, 2, '2026-09-04 19:48:43', 273.00, 13, 'Cash', 'quaso', '1234567', '123456789'),
(6, 2, '2026-09-04 19:50:12', 110.00, 10, 'Cash', '', '', ''),
(7, 2, '2026-09-04 19:50:30', 22.00, 4, 'Cash', '', '', ''),
(8, 2, '2026-09-04 19:52:27', 42.00, 2, 'Cash', 'asdas', 'asdad', 'dasd');

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
(1, 1, 'John Kaye', '', 'Fernandez', '12345678990', 'admin', 'johnkaye123', '123', 'Offline', '2026-09-04 22:27:24', '2026-09-05 01:45:57', 1),
(2, 2, 'Joseph', '', 'Osena', '09936178148', 'joseph_staff', 'osep123', '123', 'Offline', '2026-09-04 18:52:25', '2026-09-04 22:26:46', 1),
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
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
  MODIFY `batch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sales_items`
--
ALTER TABLE `sales_items`
  MODIFY `sales_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `sales_transactions`
--
ALTER TABLE `sales_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
