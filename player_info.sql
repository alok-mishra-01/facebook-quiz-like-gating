-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: May 09, 2013 at 07:10 PM
-- Server version: 5.0.96
-- PHP Version: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `quiz`
--

-- --------------------------------------------------------

--
-- Table structure for table `player_info`
--

CREATE TABLE IF NOT EXISTS `player_info` (
  `fbid` varchar(500) NOT NULL,
  `email` varchar(500) NOT NULL,
  `name` varchar(500) NOT NULL,
  `time` varchar(500) NOT NULL,
  `questions` int(10) NOT NULL,
  `score` int(10) NOT NULL,
  UNIQUE KEY `fbid` (`fbid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `player_info`
--

INSERT INTO `player_info` (`fbid`, `email`, `name`, `time`, `questions`, `score`) VALUES
('4', 'a@b.com', 'Mangal', '1719', 4, 4005817),
('6', 'a@b.com', 'John', '9892', 4, 4001010),
('8', 'a@b.com', 'Jill', '26063', 4, 4001178),
('19', 'a@b.com', 'Tom', '28063', 2, 2000356),
('20', 'a@b.com', 'Dude', '13715', 5, 5000729),
('12', 'a@b.com', 'Girl', '8292', 4, 4001205),
('45', 'a@b.com', 'Boy', '7971', 5, 5001254),
('123', 'a@b.com', 'Tranny', '3726', 3, 3002683);
