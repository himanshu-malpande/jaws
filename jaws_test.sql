-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 09, 2017 at 03:22 PM
-- Server version: 5.7.19
-- PHP Version: 7.1.10-1+ubuntu16.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jaws_test`
--
CREATE DATABASE IF NOT EXISTS `jaws_test` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `jaws_test`;

-- --------------------------------------------------------

--
-- Table structure for table `Course`
--

DROP TABLE IF EXISTS `Course`;
CREATE TABLE IF NOT EXISTS `Course` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sisId` varchar(16) DEFAULT NULL,
  `durationLength` int(11) DEFAULT NULL,
  `durationUnit` enum('days','months','years') DEFAULT NULL,
  `status` enum('published','unpublished','draft','deleted','hidden') NOT NULL DEFAULT 'draft',
  `createdBy` int(10) UNSIGNED NOT NULL,
  `updatedBy` int(10) UNSIGNED DEFAULT NULL,
  `deletedBy` int(10) UNSIGNED DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sis_id` (`sisId`),
  KEY `status` (`status`),
  KEY `created_at` (`createdAt`),
  KEY `courseCreatorUserId` (`createdBy`),
  KEY `courseUpdatorUserId` (`updatedBy`),
  KEY `courseDeleterUserId` (`deletedBy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `CourseSection`
--

DROP TABLE IF EXISTS `CourseSection`;
CREATE TABLE IF NOT EXISTS `CourseSection` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `courseId` int(10) UNSIGNED NOT NULL,
  `deliveryModeId` int(10) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL,
  `sisId` varchar(16) NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `status` enum('active','draft','deleted','expired') NOT NULL DEFAULT 'draft',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`courseId`,`startDate`),
  KEY `sis_id` (`sisId`),
  KEY `end_date` (`endDate`),
  KEY `status` (`status`),
  KEY `created_at` (`createdAt`),
  KEY `delivery_mode_id` (`deliveryModeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Currency`
--

DROP TABLE IF EXISTS `Currency`;
CREATE TABLE IF NOT EXISTS `Currency` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `exchangeRate` decimal(9,2) DEFAULT NULL,
  `addedBy` int(10) UNSIGNED NOT NULL,
  `status` enum('draft','active','disabled','deleted') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `createdAt` (`createdAt`),
  KEY `updatedAt` (`updatedAt`),
  KEY `status` (`status`),
  KEY `addedBy` (`addedBy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `DeliveryMode`
--

DROP TABLE IF EXISTS `DeliveryMode`;
CREATE TABLE IF NOT EXISTS `DeliveryMode` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  `sisId` varchar(8) NOT NULL,
  `status` enum('active','deleted','obsolete','draft') NOT NULL DEFAULT 'draft',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sis_id` (`sisId`),
  KEY `status` (`status`),
  KEY `created_at` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `LoginAttempt`
--

DROP TABLE IF EXISTS `LoginAttempt`;
CREATE TABLE IF NOT EXISTS `LoginAttempt` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` int(10) UNSIGNED NOT NULL,
  `userLoginId` int(10) UNSIGNED NOT NULL,
  `loginAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(64) DEFAULT NULL,
  `userAgent` json DEFAULT NULL,
  `httpHeaders` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`userId`),
  KEY `user_login_id` (`userLoginId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
CREATE TABLE IF NOT EXISTS `Product` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `contextType` varchar(32) DEFAULT NULL,
  `contextId` int(11) DEFAULT NULL,
  `description` text,
  `urlSlug` varchar(32) DEFAULT NULL,
  `deliveryModeId` int(11) UNSIGNED DEFAULT NULL,
  `durationUnit` enum('days','months','years') NOT NULL DEFAULT 'months',
  `durationLength` int(11) NOT NULL,
  `isVisible` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('draft','active','disabled','expired','deleted') NOT NULL DEFAULT 'draft',
  `availableFrom` datetime DEFAULT NULL,
  `availableTill` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `createdAt` (`createdAt`),
  KEY `updatedAt` (`updatedAt`),
  KEY `contextType` (`contextType`,`contextId`),
  KEY `deliveryModeId` (`deliveryModeId`),
  KEY `availableFrom` (`availableFrom`,`availableTill`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ProductPricing`
--

DROP TABLE IF EXISTS `ProductPricing`;
CREATE TABLE IF NOT EXISTS `ProductPricing` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `productId` int(10) UNSIGNED NOT NULL,
  `currencyId` int(10) UNSIGNED NOT NULL,
  `price` decimal(9,2) NOT NULL,
  `createdBy` int(10) UNSIGNED NOT NULL,
  `updatedBy` int(10) UNSIGNED DEFAULT NULL,
  `deletedBy` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('draft','active','disabled','deleted') NOT NULL DEFAULT 'active',
  `availableFrom` datetime DEFAULT NULL,
  `availableTill` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `currencyId` (`currencyId`),
  KEY `status` (`status`),
  KEY `createdAt` (`createdAt`),
  KEY `updatedAt` (`updatedAt`),
  KEY `productId` (`productId`),
  KEY `priceAdderUserIdFk` (`createdBy`),
  KEY `priceUpdaterUserIdFk` (`updatedBy`),
  KEY `priceDeleterUserIdFk` (`deletedBy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
CREATE TABLE IF NOT EXISTS `User` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(32) NOT NULL,
  `shortName` varchar(64) DEFAULT NULL,
  `firstName` varchar(16) DEFAULT NULL,
  `lastName` varchar(16) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `gender` enum('m','f') DEFAULT NULL,
  `photoUrl` text,
  `lastLoginAt` int(11) DEFAULT NULL,
  `status` enum('active','deleted','blocked') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `status` (`status`),
  KEY `created_at` (`createdAt`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `email`, `shortName`, `firstName`, `lastName`, `phone`, `gender`, `photoUrl`, `lastLoginAt`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 'himanshu@jigsawacademy.com', 'Himanshu Malpande', 'Himanshu', 'Malpande', '9407177979', 'm', NULL, NULL, 'active', '2017-09-30 01:22:44', '2017-09-30 01:22:44'),
(2, 'himanshu.malpande@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 03:59:55', '2017-09-30 03:59:55'),
(3, 'suyog.malpande@gmail.com', 'Hemant Malpande', NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 04:00:50', '2017-09-30 04:10:24'),
(5, 'suyog.malpande@outlook.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 04:05:52', '2017-09-30 04:05:52'),
(6, 'himanshu.malpande@outlook.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 04:06:30', '2017-09-30 04:06:30');

-- --------------------------------------------------------

--
-- Table structure for table `UserAddress`
--

DROP TABLE IF EXISTS `UserAddress`;
CREATE TABLE IF NOT EXISTS `UserAddress` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` int(10) UNSIGNED NOT NULL,
  `addr1` varchar(64) DEFAULT NULL,
  `addr2` varchar(64) DEFAULT NULL,
  `addr3` varchar(64) DEFAULT NULL,
  `city` varchar(16) NOT NULL,
  `state` varchar(16) DEFAULT NULL,
  `country` varchar(16) NOT NULL,
  `zip` int(11) DEFAULT NULL,
  `isCurrent` tinyint(4) NOT NULL DEFAULT '1',
  `status` enum('active','deleted') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`userId`),
  KEY `country` (`country`),
  KEY `created_at` (`createdAt`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `UserLogin`
--

DROP TABLE IF EXISTS `UserLogin`;
CREATE TABLE IF NOT EXISTS `UserLogin` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` int(10) UNSIGNED NOT NULL,
  `email` varchar(64) DEFAULT NULL,
  `sisId` varchar(16) DEFAULT NULL,
  `loginChannelId` int(11) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `status` enum('active','blocked','deleted') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`userId`),
  KEY `email` (`email`),
  KEY `sis_id` (`sisId`),
  KEY `login_channel_id` (`loginChannelId`),
  KEY `created_at` (`createdAt`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Course`
--
ALTER TABLE `Course`
  ADD CONSTRAINT `courseCreatorUserId` FOREIGN KEY (`createdBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `courseDeleterUserId` FOREIGN KEY (`deletedBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `courseUpdatorUserId` FOREIGN KEY (`updatedBy`) REFERENCES `User` (`id`);

--
-- Constraints for table `CourseSection`
--
ALTER TABLE `CourseSection`
  ADD CONSTRAINT `sectionCourseIdFk` FOREIGN KEY (`courseId`) REFERENCES `Course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sectionDeliveryModeIdFk` FOREIGN KEY (`deliveryModeId`) REFERENCES `DeliveryMode` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Currency`
--
ALTER TABLE `Currency`
  ADD CONSTRAINT `currencyUserIdFk` FOREIGN KEY (`addedBy`) REFERENCES `User` (`id`);

--
-- Constraints for table `LoginAttempt`
--
ALTER TABLE `LoginAttempt`
  ADD CONSTRAINT `loginAttemptUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `loginAttemptUserLoginIdFk` FOREIGN KEY (`userLoginId`) REFERENCES `UserLogin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `productDeliveryModeFk` FOREIGN KEY (`deliveryModeId`) REFERENCES `DeliveryMode` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ProductPricing`
--
ALTER TABLE `ProductPricing`
  ADD CONSTRAINT `priceAdderUserIdFk` FOREIGN KEY (`createdBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `priceDeleterUserIdFk` FOREIGN KEY (`deletedBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `priceUpdaterUserIdFk` FOREIGN KEY (`updatedBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `pricingCurrencyId` FOREIGN KEY (`currencyId`) REFERENCES `Course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pricingProductIdFk` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `UserAddress`
--
ALTER TABLE `UserAddress`
  ADD CONSTRAINT `userAddrUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `UserLogin`
--
ALTER TABLE `UserLogin`
  ADD CONSTRAINT `userLoginUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
