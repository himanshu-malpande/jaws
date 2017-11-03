-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 03, 2017 at 11:19 AM
-- Server version: 5.7.19
-- PHP Version: 7.2.0RC2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jaws_dev`
--
CREATE DATABASE IF NOT EXISTS `jaws_dev` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `jaws_dev`;

-- --------------------------------------------------------

--
-- Table structure for table `Course`
--

DROP TABLE IF EXISTS `Course`;
CREATE TABLE `Course` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(64) NOT NULL,
  `sisId` varchar(16) DEFAULT NULL,
  `position` int(10) UNSIGNED NOT NULL,
  `durationLength` int(11) DEFAULT NULL,
  `durationUnit` enum('days','months','years') DEFAULT NULL,
  `statusId` int(11) UNSIGNED NOT NULL DEFAULT '6' COMMENT 'Possible statuses are: ''published'',''unpublished'',''draft'',''deleted'',''hidden''',
  `createdBy` int(10) UNSIGNED NOT NULL,
  `updatedBy` int(10) UNSIGNED DEFAULT NULL,
  `deletedBy` int(10) UNSIGNED DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `CourseSection`
--

DROP TABLE IF EXISTS `CourseSection`;
CREATE TABLE `CourseSection` (
  `id` int(10) UNSIGNED NOT NULL,
  `courseId` int(10) UNSIGNED NOT NULL,
  `deliveryModeId` int(10) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL,
  `sisId` varchar(16) NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `statusId` int(10) UNSIGNED NOT NULL DEFAULT '6' COMMENT 'Possible statuses are: ''active'',''draft'',''deleted'',''expired''',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Currency`
--

DROP TABLE IF EXISTS `Currency`;
CREATE TABLE `Currency` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(3) NOT NULL,
  `exchangeRate` decimal(9,2) DEFAULT NULL,
  `addedBy` int(10) UNSIGNED NOT NULL,
  `statusId` int(10) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Possible statuses are: ''draft'',''active'',''disabled'',''deleted''',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `DeliveryMode`
--

DROP TABLE IF EXISTS `DeliveryMode`;
CREATE TABLE `DeliveryMode` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(16) NOT NULL,
  `sisId` varchar(8) NOT NULL,
  `status` enum('active','deleted','obsolete','draft') NOT NULL DEFAULT 'draft',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Enrolment`
--

DROP TABLE IF EXISTS `Enrolment`;
CREATE TABLE `Enrolment` (
  `id` int(10) UNSIGNED NOT NULL,
  `userId` int(10) UNSIGNED NOT NULL,
  `courseId` int(10) UNSIGNED NOT NULL,
  `courseSectionId` int(10) UNSIGNED NOT NULL,
  `status` enum('pending','active','blocked','deleted','expired') NOT NULL DEFAULT 'pending',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `HttpClient`
--

DROP TABLE IF EXISTS `HttpClient`;
CREATE TABLE `HttpClient` (
  `id` int(10) UNSIGNED NOT NULL,
  `uuid` varchar(64) NOT NULL,
  `userId` int(10) UNSIGNED DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `HttpRequest`
--

DROP TABLE IF EXISTS `HttpRequest`;
CREATE TABLE `HttpRequest` (
  `id` int(10) UNSIGNED NOT NULL,
  `httpClientId` int(10) UNSIGNED DEFAULT NULL,
  `url` varchar(1024) NOT NULL,
  `method` enum('get','post','delete','patch','put','head','connect','options') DEFAULT NULL,
  `ip` varchar(64) NOT NULL,
  `referer` varchar(1024) DEFAULT NULL,
  `httpHeader` json DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Instalment`
--

DROP TABLE IF EXISTS `Instalment`;
CREATE TABLE `Instalment` (
  `id` int(10) UNSIGNED NOT NULL,
  `paymentId` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED NOT NULL,
  `instalmentCount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `currencyId` int(10) UNSIGNED NOT NULL,
  `instalmentAmount` decimal(9,2) UNSIGNED NOT NULL,
  `instalmentCharge` decimal(9,2) UNSIGNED NOT NULL,
  `taxPercentage` decimal(3,2) UNSIGNED NOT NULL,
  `taxAmount` decimal(9,2) UNSIGNED NOT NULL,
  `taxBreakup` json DEFAULT NULL,
  `payableAmount` decimal(9,2) UNSIGNED NOT NULL,
  `paidBy` int(10) UNSIGNED DEFAULT NULL,
  `paymentDate` datetime DEFAULT NULL,
  `paymentMethod` enum('cc','dc','nb','gateway','cash','cheque','dd','external','coupon','other') DEFAULT NULL,
  `paymentInfo` text,
  `dueDate` date DEFAULT NULL,
  `expiryDate` date DEFAULT NULL,
  `overdueCharge` decimal(9,2) DEFAULT NULL,
  `status` enum('pending','paid','failed','disabled') NOT NULL DEFAULT 'pending',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Lab`
--

DROP TABLE IF EXISTS `Lab`;
CREATE TABLE `Lab` (
  `id` int(10) UNSIGNED NOT NULL,
  `courseId` int(10) UNSIGNED NOT NULL,
  `serverUri` varchar(128) NOT NULL,
  `port` int(5) DEFAULT NULL,
  `documentRoot` varchar(256) DEFAULT NULL,
  `usersCount` int(10) UNSIGNED NOT NULL,
  `status` enum('active','expired','deleted') NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `LabAccess`
--

DROP TABLE IF EXISTS `LabAccess`;
CREATE TABLE `LabAccess` (
  `id` int(10) UNSIGNED NOT NULL,
  `userId` int(10) UNSIGNED NOT NULL,
  `labId` int(10) UNSIGNED NOT NULL,
  `username` varchar(16) NOT NULL,
  `password` varchar(32) NOT NULL,
  `status` enum('pending','active','blocked','deleted','expired') NOT NULL DEFAULT 'pending',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `LoginAttempt`
--

DROP TABLE IF EXISTS `LoginAttempt`;
CREATE TABLE `LoginAttempt` (
  `id` int(10) UNSIGNED NOT NULL,
  `userId` int(10) UNSIGNED NOT NULL,
  `userAuthId` int(10) UNSIGNED NOT NULL,
  `userSessionId` int(10) UNSIGNED NOT NULL,
  `loginAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(64) DEFAULT NULL,
  `userAgent` json DEFAULT NULL,
  `httpHeaders` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `LoginChannel`
--

DROP TABLE IF EXISTS `LoginChannel`;
CREATE TABLE `LoginChannel` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(16) NOT NULL,
  `shortName` varchar(2) NOT NULL,
  `authKey` varchar(128) NOT NULL,
  `authSecret` varchar(128) DEFAULT NULL,
  `status` enum('active','deleted','blocked') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Order`
--

DROP TABLE IF EXISTS `Order`;
CREATE TABLE `Order` (
  `id` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED NOT NULL,
  `creatorId` int(10) UNSIGNED NOT NULL,
  `status` enum('draft','pending','approved','rejected','executed','fullfilled','deleted') NOT NULL DEFAULT 'executed',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `OrderAuthorization`
--

DROP TABLE IF EXISTS `OrderAuthorization`;
CREATE TABLE `OrderAuthorization` (
  `id` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `authorizationStatus` enum('approved','rejected') NOT NULL,
  `authorityId` int(10) UNSIGNED NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `OrderEntity`
--

DROP TABLE IF EXISTS `OrderEntity`;
CREATE TABLE `OrderEntity` (
  `id` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED NOT NULL,
  `contextType` varchar(16) NOT NULL,
  `contextId` int(10) UNSIGNED NOT NULL,
  `status` enum('inactive','active','processed','removed','blocked','expired') NOT NULL DEFAULT 'active',
  `removedBy` int(10) UNSIGNED DEFAULT NULL,
  `removeComment` text,
  `blockedBy` int(10) UNSIGNED DEFAULT NULL,
  `blockedComment` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `OrderEntityValidity`
--

DROP TABLE IF EXISTS `OrderEntityValidity`;
CREATE TABLE `OrderEntityValidity` (
  `id` int(10) UNSIGNED NOT NULL,
  `orderEntityId` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `durationLength` int(11) NOT NULL,
  `durationUnit` enum('days','months','years') NOT NULL DEFAULT 'months',
  `status` enum('active','deleted','blocked','expired','frozen') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Payment`
--

DROP TABLE IF EXISTS `Payment`;
CREATE TABLE `Payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `currencyId` int(10) UNSIGNED NOT NULL,
  `originalAmount` decimal(9,2) UNSIGNED NOT NULL,
  `preTaxAmount` decimal(9,2) UNSIGNED NOT NULL,
  `taxPercentage` decimal(2,2) UNSIGNED NOT NULL,
  `taxAmount` decimal(9,2) NOT NULL,
  `discountPercentage` decimal(3,2) DEFAULT NULL,
  `discountAmount` decimal(9,2) DEFAULT NULL,
  `payableAmount` decimal(9,2) UNSIGNED NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
CREATE TABLE `Product` (
  `id` int(10) UNSIGNED NOT NULL,
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
  `updatedAt` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ProductPricing`
--

DROP TABLE IF EXISTS `ProductPricing`;
CREATE TABLE `ProductPricing` (
  `id` int(10) UNSIGNED NOT NULL,
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
  `updatedAt` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Refund`
--

DROP TABLE IF EXISTS `Refund`;
CREATE TABLE `Refund` (
  `id` int(10) UNSIGNED NOT NULL,
  `paymentId` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED NOT NULL,
  `refundAmount` decimal(9,2) UNSIGNED NOT NULL,
  `refundDate` datetime NOT NULL,
  `processedBy` int(10) UNSIGNED DEFAULT NULL,
  `comments` text NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Status`
--

DROP TABLE IF EXISTS `Status`;
CREATE TABLE `Status` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(16) NOT NULL,
  `description` text,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Status`
--

INSERT INTO `Status` (`id`, `code`, `description`, `createdAt`, `updatedAt`) VALUES
(1, 'active', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(2, 'approved', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(3, 'blocked', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(4, 'deleted', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(5, 'disabled', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(6, 'draft', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(7, 'executed', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(8, 'expired', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(9, 'failed', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(10, 'frozen', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(11, 'fulfilled', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(12, 'hidden', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(13, 'inactive', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(14, 'obsolete', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(15, 'paid', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(16, 'pending', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(17, 'processed', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(18, 'published', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(19, 'rejected', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(20, 'removed', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07'),
(21, 'unpublished', NULL, '2017-11-03 15:18:07', '2017-11-03 15:18:07');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(32) NOT NULL,
  `shortName` varchar(64) DEFAULT NULL,
  `firstName` varchar(16) DEFAULT NULL,
  `lastName` varchar(16) DEFAULT NULL,
  `fullName` varchar(64) DEFAULT NULL,
  `countryCode` int(2) DEFAULT NULL,
  `phone` int(10) UNSIGNED DEFAULT NULL,
  `countryCode_2` int(2) UNSIGNED DEFAULT NULL,
  `phone_2` int(10) UNSIGNED DEFAULT NULL,
  `countryCode_3` int(2) UNSIGNED DEFAULT NULL,
  `phone_3` int(10) UNSIGNED DEFAULT NULL,
  `gender` enum('m','f') DEFAULT NULL,
  `photoUrl` text,
  `lastLoginAt` int(11) DEFAULT NULL,
  `status` enum('active','deleted','blocked','frozen') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `email`, `shortName`, `firstName`, `lastName`, `fullName`, `countryCode`, `phone`, `countryCode_2`, `phone_2`, `countryCode_3`, `phone_3`, `gender`, `photoUrl`, `lastLoginAt`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 'himanshu@jigsawacademy.com', 'Himanshu Malpande', 'Himanshu', 'Malpande', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'm', NULL, NULL, 'active', '2017-09-30 01:22:44', '2017-09-30 01:22:44'),
(2, 'himanshu.malpande@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 03:59:55', '2017-09-30 03:59:55'),
(3, 'suyog.malpande@gmail.com', 'Hemant Malpande', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 04:00:50', '2017-09-30 04:10:24'),
(5, 'suyog.malpande@outlook.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 04:05:52', '2017-09-30 04:05:52'),
(6, 'himanshu.malpande@outlook.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', '2017-09-30 04:06:30', '2017-09-30 04:06:30');

-- --------------------------------------------------------

--
-- Table structure for table `UserAddress`
--

DROP TABLE IF EXISTS `UserAddress`;
CREATE TABLE `UserAddress` (
  `id` int(10) UNSIGNED NOT NULL,
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
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `UserAuth`
--

DROP TABLE IF EXISTS `UserAuth`;
CREATE TABLE `UserAuth` (
  `id` int(10) UNSIGNED NOT NULL,
  `userId` int(10) UNSIGNED NOT NULL,
  `email` varchar(64) DEFAULT NULL,
  `sisId` varchar(16) DEFAULT NULL,
  `loginChannelId` int(11) UNSIGNED DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `status` enum('active','blocked','deleted') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `UserAuth`
--

INSERT INTO `UserAuth` (`id`, `userId`, `email`, `sisId`, `loginChannelId`, `password`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 1, 'himanshu@jigsawacademy.com', NULL, NULL, 'e4016e94ad4f1351ac8521a9ef95f66294be60d56401b65e4ba0ce72415f4dc6', 'active', '2017-10-19 11:39:14', '2017-10-19 13:11:51');

-- --------------------------------------------------------

--
-- Table structure for table `UserFreeze`
--

DROP TABLE IF EXISTS `UserFreeze`;
CREATE TABLE `UserFreeze` (
  `id` int(10) UNSIGNED NOT NULL,
  `userId` int(10) UNSIGNED NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `requestedBy` int(10) UNSIGNED DEFAULT NULL,
  `requestedAt` datetime DEFAULT NULL,
  `approvedBy` int(10) UNSIGNED DEFAULT NULL,
  `approvedAt` datetime DEFAULT NULL,
  `status` enum('pending','active','deleted') NOT NULL,
  `comments` json DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `UserSession`
--

DROP TABLE IF EXISTS `UserSession`;
CREATE TABLE `UserSession` (
  `id` int(10) UNSIGNED NOT NULL,
  `userId` int(10) UNSIGNED NOT NULL,
  `sessionId` varchar(32) NOT NULL,
  `clientInfo` json DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Course`
--
ALTER TABLE `Course`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `position` (`position`),
  ADD KEY `courseCreatorUserId` (`createdBy`),
  ADD KEY `courseUpdatorUserId` (`updatedBy`),
  ADD KEY `courseDeleterUserId` (`deletedBy`),
  ADD KEY `sisId` (`sisId`) USING BTREE,
  ADD KEY `statusId` (`statusId`) USING BTREE,
  ADD KEY `createdAt` (`createdAt`) USING BTREE;

--
-- Indexes for table `CourseSection`
--
ALTER TABLE `CourseSection`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courseId` (`courseId`,`startDate`) USING BTREE,
  ADD KEY `sisId` (`sisId`) USING BTREE,
  ADD KEY `endDate` (`endDate`) USING BTREE,
  ADD KEY `createdAt` (`createdAt`) USING BTREE,
  ADD KEY `deliveryModeId` (`deliveryModeId`) USING BTREE,
  ADD KEY `statusId` (`statusId`) USING BTREE;

--
-- Indexes for table `Currency`
--
ALTER TABLE `Currency`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `status` (`statusId`),
  ADD KEY `addedBy` (`addedBy`);

--
-- Indexes for table `DeliveryMode`
--
ALTER TABLE `DeliveryMode`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sis_id` (`sisId`),
  ADD KEY `status` (`status`),
  ADD KEY `created_at` (`createdAt`);

--
-- Indexes for table `Enrolment`
--
ALTER TABLE `Enrolment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `courseId` (`courseId`),
  ADD KEY `courseSectionId` (`courseSectionId`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `HttpClient`
--
ALTER TABLE `HttpClient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uuid` (`uuid`),
  ADD KEY `userId` (`userId`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `HttpRequest`
--
ALTER TABLE `HttpRequest`
  ADD PRIMARY KEY (`id`),
  ADD KEY `httpClientId` (`httpClientId`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `Instalment`
--
ALTER TABLE `Instalment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `paymentId` (`paymentId`),
  ADD KEY `orderId` (`orderId`),
  ADD KEY `customerId` (`customerId`),
  ADD KEY `paymentDate` (`paymentDate`),
  ADD KEY `paymentMethod` (`paymentMethod`),
  ADD KEY `dueDate` (`dueDate`),
  ADD KEY `expiryDate` (`expiryDate`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `status` (`status`),
  ADD KEY `currencyId` (`currencyId`),
  ADD KEY `paidBy` (`paidBy`);

--
-- Indexes for table `Lab`
--
ALTER TABLE `Lab`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courseId` (`courseId`),
  ADD KEY `serverIp` (`serverUri`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `usersCount` (`usersCount`);

--
-- Indexes for table `LabAccess`
--
ALTER TABLE `LabAccess`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `labId` (`labId`),
  ADD KEY `username` (`username`),
  ADD KEY `password` (`password`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `LoginAttempt`
--
ALTER TABLE `LoginAttempt`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`userId`),
  ADD KEY `user_login_id` (`userAuthId`),
  ADD KEY `userSessionId` (`userSessionId`);

--
-- Indexes for table `LoginChannel`
--
ALTER TABLE `LoginChannel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `shortName` (`shortName`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `Order`
--
ALTER TABLE `Order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`customerId`),
  ADD KEY `creatorId` (`creatorId`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `OrderAuthorization`
--
ALTER TABLE `OrderAuthorization`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orderId` (`orderId`),
  ADD KEY `authorizationStatus` (`authorizationStatus`),
  ADD KEY `authorityId` (`authorityId`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `OrderEntity`
--
ALTER TABLE `OrderEntity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orderId` (`orderId`),
  ADD KEY `userId` (`customerId`),
  ADD KEY `contextType` (`contextType`,`contextId`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `status` (`status`),
  ADD KEY `removedBy` (`removedBy`),
  ADD KEY `blockedBy` (`blockedBy`);

--
-- Indexes for table `OrderEntityValidity`
--
ALTER TABLE `OrderEntityValidity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orderEntityId` (`orderEntityId`),
  ADD KEY `orderId` (`orderId`),
  ADD KEY `customerId` (`customerId`),
  ADD KEY `startDate` (`startDate`),
  ADD KEY `endDate` (`endDate`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `Payment`
--
ALTER TABLE `Payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`customerId`),
  ADD KEY `orderId` (`orderId`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `currencyId` (`currencyId`);

--
-- Indexes for table `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `contextType` (`contextType`,`contextId`),
  ADD KEY `deliveryModeId` (`deliveryModeId`),
  ADD KEY `availableFrom` (`availableFrom`,`availableTill`);

--
-- Indexes for table `ProductPricing`
--
ALTER TABLE `ProductPricing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `currencyId` (`currencyId`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `productId` (`productId`),
  ADD KEY `priceAdderUserIdFk` (`createdBy`),
  ADD KEY `priceUpdaterUserIdFk` (`updatedBy`),
  ADD KEY `priceDeleterUserIdFk` (`deletedBy`);

--
-- Indexes for table `Refund`
--
ALTER TABLE `Refund`
  ADD PRIMARY KEY (`id`),
  ADD KEY `paymentId` (`paymentId`),
  ADD KEY `orderId` (`orderId`),
  ADD KEY `customerId` (`customerId`),
  ADD KEY `refundDate` (`refundDate`),
  ADD KEY `processedBy` (`processedBy`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `Status`
--
ALTER TABLE `Status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `status` (`status`),
  ADD KEY `created_at` (`createdAt`),
  ADD KEY `phone` (`phone`);

--
-- Indexes for table `UserAddress`
--
ALTER TABLE `UserAddress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`userId`),
  ADD KEY `country` (`country`),
  ADD KEY `created_at` (`createdAt`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `UserAuth`
--
ALTER TABLE `UserAuth`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`userId`),
  ADD KEY `email` (`email`),
  ADD KEY `sis_id` (`sisId`),
  ADD KEY `login_channel_id` (`loginChannelId`),
  ADD KEY `created_at` (`createdAt`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `UserFreeze`
--
ALTER TABLE `UserFreeze`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `startDate` (`startDate`),
  ADD KEY `endDate` (`endDate`),
  ADD KEY `status` (`status`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`),
  ADD KEY `userFreezeRequestedByUserFk` (`requestedBy`),
  ADD KEY `userFreezeApprovedByUserFk` (`approvedBy`);

--
-- Indexes for table `UserSession`
--
ALTER TABLE `UserSession`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `sessionId` (`sessionId`),
  ADD KEY `createdAt` (`createdAt`),
  ADD KEY `updatedAt` (`updatedAt`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Course`
--
ALTER TABLE `Course`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `CourseSection`
--
ALTER TABLE `CourseSection`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Currency`
--
ALTER TABLE `Currency`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `DeliveryMode`
--
ALTER TABLE `DeliveryMode`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Enrolment`
--
ALTER TABLE `Enrolment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `HttpClient`
--
ALTER TABLE `HttpClient`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `HttpRequest`
--
ALTER TABLE `HttpRequest`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Instalment`
--
ALTER TABLE `Instalment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Lab`
--
ALTER TABLE `Lab`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `LabAccess`
--
ALTER TABLE `LabAccess`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `LoginAttempt`
--
ALTER TABLE `LoginAttempt`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `LoginChannel`
--
ALTER TABLE `LoginChannel`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Order`
--
ALTER TABLE `Order`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderAuthorization`
--
ALTER TABLE `OrderAuthorization`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderEntity`
--
ALTER TABLE `OrderEntity`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderEntityValidity`
--
ALTER TABLE `OrderEntityValidity`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Payment`
--
ALTER TABLE `Payment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Product`
--
ALTER TABLE `Product`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ProductPricing`
--
ALTER TABLE `ProductPricing`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Refund`
--
ALTER TABLE `Refund`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Status`
--
ALTER TABLE `Status`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `UserAddress`
--
ALTER TABLE `UserAddress`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `UserAuth`
--
ALTER TABLE `UserAuth`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `UserFreeze`
--
ALTER TABLE `UserFreeze`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `UserSession`
--
ALTER TABLE `UserSession`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Course`
--
ALTER TABLE `Course`
  ADD CONSTRAINT `courseCreatorUserIdFk` FOREIGN KEY (`createdBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `courseDeleterUserIdFk` FOREIGN KEY (`deletedBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `courseStatusIdStatusIdFk` FOREIGN KEY (`statusId`) REFERENCES `Status` (`id`),
  ADD CONSTRAINT `courseUpdatorUserIdFk` FOREIGN KEY (`updatedBy`) REFERENCES `User` (`id`);

--
-- Constraints for table `CourseSection`
--
ALTER TABLE `CourseSection`
  ADD CONSTRAINT `sectionCourseIdFk` FOREIGN KEY (`courseId`) REFERENCES `Course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sectionDeliveryModeIdFk` FOREIGN KEY (`deliveryModeId`) REFERENCES `DeliveryMode` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sectionStatusIdStatusIdFk` FOREIGN KEY (`statusId`) REFERENCES `Status` (`id`);

--
-- Constraints for table `Currency`
--
ALTER TABLE `Currency`
  ADD CONSTRAINT `currencyStatusIdFk` FOREIGN KEY (`statusId`) REFERENCES `Status` (`id`),
  ADD CONSTRAINT `currencyUserIdFk` FOREIGN KEY (`addedBy`) REFERENCES `User` (`id`);

--
-- Constraints for table `Enrolment`
--
ALTER TABLE `Enrolment`
  ADD CONSTRAINT `enrolmentCourseIdCourseFk` FOREIGN KEY (`courseId`) REFERENCES `Course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `enrolmentCourseSectionIdCourseSectionFk` FOREIGN KEY (`courseSectionId`) REFERENCES `CourseSection` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `enrolmentUserIdUserFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `HttpClient`
--
ALTER TABLE `HttpClient`
  ADD CONSTRAINT `httpClientUserIdUserFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `HttpRequest`
--
ALTER TABLE `HttpRequest`
  ADD CONSTRAINT `httpRequestHttpClientIdHttpClientFk` FOREIGN KEY (`httpClientId`) REFERENCES `HttpClient` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `Instalment`
--
ALTER TABLE `Instalment`
  ADD CONSTRAINT `instalmentCurrencyIdCurrencyFk` FOREIGN KEY (`currencyId`) REFERENCES `Currency` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `instalmentCustomerIdUserFk` FOREIGN KEY (`customerId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `instalmentOrderIdOrderFk` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `instalmentPaidByUserFk` FOREIGN KEY (`paidBy`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `instalmentPaymentIdPaymentFk` FOREIGN KEY (`paymentId`) REFERENCES `Payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Lab`
--
ALTER TABLE `Lab`
  ADD CONSTRAINT `labCourseIdCourseFk` FOREIGN KEY (`courseId`) REFERENCES `Course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `LabAccess`
--
ALTER TABLE `LabAccess`
  ADD CONSTRAINT `labAccessLabIdLabFk` FOREIGN KEY (`labId`) REFERENCES `Lab` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `labAccessUserIdUserFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `LoginAttempt`
--
ALTER TABLE `LoginAttempt`
  ADD CONSTRAINT `loginAttemptUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `loginAttemptUserLoginIdFk` FOREIGN KEY (`userAuthId`) REFERENCES `UserAuth` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `loginAttemptUserSessionIdFk` FOREIGN KEY (`userSessionId`) REFERENCES `UserSession` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Order`
--
ALTER TABLE `Order`
  ADD CONSTRAINT `orderCreatorIdUserFk` FOREIGN KEY (`creatorId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderUserIdUserFk` FOREIGN KEY (`customerId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `OrderAuthorization`
--
ALTER TABLE `OrderAuthorization`
  ADD CONSTRAINT `orderAuthAuthorityIdUserFk` FOREIGN KEY (`authorityId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderAuthOrderIdOrderFk` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `OrderEntity`
--
ALTER TABLE `OrderEntity`
  ADD CONSTRAINT `orderDetailBlockedByUserFk` FOREIGN KEY (`blockedBy`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `orderDetailOrderIdOrderFk` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderDetailRemovedByUserFk` FOREIGN KEY (`removedBy`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `orderDetailUserIdUserFk` FOREIGN KEY (`customerId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `OrderEntityValidity`
--
ALTER TABLE `OrderEntityValidity`
  ADD CONSTRAINT `orderEntityCustomerIdUserFk` FOREIGN KEY (`customerId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderEntityValidityEntityIdOrderEntityFk` FOREIGN KEY (`orderEntityId`) REFERENCES `OrderEntity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderEntityValidityOrderIdOrderFk` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Payment`
--
ALTER TABLE `Payment`
  ADD CONSTRAINT `paymentCurrencyIdCurrencyFk` FOREIGN KEY (`currencyId`) REFERENCES `Currency` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `paymentOrderIdOrderFk` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `paymentUserIdUserFk` FOREIGN KEY (`customerId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `Refund`
--
ALTER TABLE `Refund`
  ADD CONSTRAINT `refundCustomerIdUserFk` FOREIGN KEY (`customerId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `refundOrderIdOrderFk` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `refundPaymentIdPaymentFk` FOREIGN KEY (`paymentId`) REFERENCES `Payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `refundProcessedByUserFk` FOREIGN KEY (`processedBy`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `UserAddress`
--
ALTER TABLE `UserAddress`
  ADD CONSTRAINT `userAddrUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `UserAuth`
--
ALTER TABLE `UserAuth`
  ADD CONSTRAINT `userAuthLoginChannelIdLoginChannelFk` FOREIGN KEY (`loginChannelId`) REFERENCES `LoginChannel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userAuthUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `UserFreeze`
--
ALTER TABLE `UserFreeze`
  ADD CONSTRAINT `userFreezeApprovedByUserFk` FOREIGN KEY (`approvedBy`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userFreezeRequestedByUserFk` FOREIGN KEY (`requestedBy`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userFreezeUserIdUserFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `UserSession`
--
ALTER TABLE `UserSession`
  ADD CONSTRAINT `userSessionUserIdFk` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
