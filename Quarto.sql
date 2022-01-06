-- phpMyAdmin SQL Dump
-- version 4.7.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jan 06, 2022 at 09:10 PM
-- Server version: 10.3.31-MariaDB-0+deb10u1-log
-- PHP Version: 7.3.31-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Quarto`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_board` ()  BEGIN
REPLACE INTO board SELECT * FROM empty_board;
UPDATE `players` SET `username`=null;
UPDATE `game_status` SET `status`='not active', `p_turn`=null, `result`=null;
REPLACE INTO pieces_board SELECT * FROM full_pieces_board;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `move_piece` (`x1` TINYINT, `y1` TINYINT, `x2` TINYINT, `y2` TINYINT)  BEGIN
DECLARE p_height, p_color, p_shape, p_hollow CHAR;
SELECT piece_height, piece_color, piece_shape, piece_hollow INTO p_height, p_color, p_shape, p_hollow
FROM `pieces_board` WHERE X=x1 AND Y=y1;
UPDATE board
SET piece_height=p_height, piece_color=p_color, piece_shape=p_shape, piece_hollow=p_hollow
WHERE X=x2 AND Y=y2;
UPDATE pieces_board
SET piece_height=NULL,piece_color=NULL,piece_shape=NULL,piece_hollow=NULL
WHERE X=x1 AND Y=y1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `board`
--

CREATE TABLE `board` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `piece_color` enum('W','B') DEFAULT NULL,
  `piece_height` enum('T','S') DEFAULT NULL,
  `piece_shape` enum('S','C') DEFAULT NULL,
  `piece_hollow` enum('Y','N') DEFAULT NULL,
  `game_id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `board`
--

INSERT INTO `board` (`x`, `y`, `piece_color`, `piece_height`, `piece_shape`, `piece_hollow`, `game_id`) VALUES
(1, 1, NULL, NULL, NULL, NULL, 0),
(1, 2, NULL, NULL, NULL, NULL, 0),
(1, 3, NULL, NULL, NULL, NULL, 0),
(1, 4, NULL, NULL, NULL, NULL, 0),
(2, 1, NULL, NULL, NULL, NULL, 0),
(2, 2, NULL, NULL, NULL, NULL, 0),
(2, 3, NULL, NULL, NULL, NULL, 0),
(2, 4, NULL, NULL, NULL, NULL, 0),
(3, 1, NULL, NULL, NULL, NULL, 0),
(3, 2, NULL, NULL, NULL, NULL, 0),
(3, 3, NULL, NULL, NULL, NULL, 0),
(3, 4, NULL, NULL, NULL, NULL, 0),
(4, 1, NULL, NULL, NULL, NULL, 0),
(4, 2, NULL, NULL, NULL, NULL, 0),
(4, 3, NULL, NULL, NULL, NULL, 0),
(4, 4, NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `empty_board`
--

CREATE TABLE `empty_board` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `piece_color` enum('W','B') DEFAULT NULL,
  `piece_height` enum('T','S') DEFAULT NULL,
  `piece_shape` enum('S','C') DEFAULT NULL,
  `piece_hollow` enum('Y','N') DEFAULT NULL,
  `game_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `empty_board`
--

INSERT INTO `empty_board` (`x`, `y`, `piece_color`, `piece_height`, `piece_shape`, `piece_hollow`, `game_id`) VALUES
(1, 1, NULL, NULL, NULL, NULL, 0),
(1, 2, NULL, NULL, NULL, NULL, 0),
(1, 3, NULL, NULL, NULL, NULL, 0),
(1, 4, NULL, NULL, NULL, NULL, 0),
(2, 1, NULL, NULL, NULL, NULL, 0),
(2, 2, NULL, NULL, NULL, NULL, 0),
(2, 3, NULL, NULL, NULL, NULL, 0),
(2, 4, NULL, NULL, NULL, NULL, 0),
(3, 1, NULL, NULL, NULL, NULL, 0),
(3, 2, NULL, NULL, NULL, NULL, 0),
(3, 3, NULL, NULL, NULL, NULL, 0),
(3, 4, NULL, NULL, NULL, NULL, 0),
(4, 1, NULL, NULL, NULL, NULL, 0),
(4, 2, NULL, NULL, NULL, NULL, 0),
(4, 3, NULL, NULL, NULL, NULL, 0),
(4, 4, NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `full_pieces_board`
--

CREATE TABLE `full_pieces_board` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `piece_color` enum('W','B') DEFAULT NULL,
  `piece_height` enum('T','S') DEFAULT NULL,
  `piece_shape` enum('S','C') DEFAULT NULL,
  `piece_hollow` enum('Y','N') DEFAULT NULL,
  `game_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `full_pieces_board`
--

INSERT INTO `full_pieces_board` (`x`, `y`, `piece_color`, `piece_height`, `piece_shape`, `piece_hollow`, `game_id`) VALUES
(1, 1, 'W', 'T', 'S', 'N', 0),
(1, 2, 'W', 'T', 'S', 'Y', 0),
(1, 3, 'W', 'S', 'S', 'N', 0),
(1, 4, 'W', 'S', 'S', 'Y', 0),
(1, 5, 'W', 'T', 'C', 'N', 0),
(1, 6, 'W', 'T', 'C', 'Y', 0),
(1, 7, 'W', 'S', 'C', 'N', 0),
(1, 8, 'W', 'S', 'C', 'Y', 0),
(2, 1, 'B', 'T', 'S', 'N', 0),
(2, 2, 'B', 'T', 'S', 'Y', 0),
(2, 3, 'B', 'S', 'S', 'N', 0),
(2, 4, 'B', 'S', 'S', 'Y', 0),
(2, 5, 'B', 'T', 'C', 'N', 0),
(2, 6, 'B', 'T', 'C', 'Y', 0),
(2, 7, 'B', 'S', 'C', 'N', 0),
(2, 8, 'B', 'S', 'C', 'Y', 0);

-- --------------------------------------------------------

--
-- Table structure for table `game`
--

CREATE TABLE `game` (
  `game_id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `game_status`
--

CREATE TABLE `game_status` (
  `status` enum('not active','initialized','started','\r\nended','aborded') NOT NULL DEFAULT 'not active',
  `p_turn` enum('A','B') DEFAULT NULL,
  `result` enum('A','B','D') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `game_status`
--
DELIMITER $$
CREATE TRIGGER `game_status_update` BEFORE UPDATE ON `game_status` FOR EACH ROW BEGIN
SET NEW.last_change = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pieces_board`
--

CREATE TABLE `pieces_board` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `piece_color` enum('W','B') DEFAULT NULL,
  `piece_height` enum('T','S') DEFAULT NULL,
  `piece_shape` enum('S','C') DEFAULT NULL,
  `piece_hollow` enum('Y','N') DEFAULT NULL,
  `game_id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pieces_board`
--

INSERT INTO `pieces_board` (`x`, `y`, `piece_color`, `piece_height`, `piece_shape`, `piece_hollow`, `game_id`) VALUES
(1, 1, 'W', 'T', 'S', 'N', 0),
(1, 2, 'W', 'T', 'S', 'Y', 0),
(1, 3, 'W', 'S', 'S', 'N', 0),
(1, 4, 'W', 'S', 'S', 'Y', 0),
(1, 5, 'W', 'T', 'C', 'N', 0),
(1, 6, 'W', 'T', 'C', 'Y', 0),
(1, 7, 'W', 'S', 'C', 'N', 0),
(1, 8, 'W', 'S', 'C', 'Y', 0),
(2, 1, 'B', 'T', 'S', 'N', 0),
(2, 2, 'B', 'T', 'S', 'Y', 0),
(2, 3, 'B', 'S', 'S', 'N', 0),
(2, 4, 'B', 'S', 'S', 'Y', 0),
(2, 5, 'B', 'T', 'C', 'N', 0),
(2, 6, 'B', 'T', 'C', 'Y', 0),
(2, 7, 'B', 'S', 'C', 'N', 0),
(2, 8, 'B', 'S', 'C', 'Y', 0);

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_nopad_ci DEFAULT NULL,
  `game_id` int(20) NOT NULL,
  `player` enum('A','B') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `board`
--
ALTER TABLE `board`
  ADD PRIMARY KEY (`x`,`y`,`game_id`);

--
-- Indexes for table `empty_board`
--
ALTER TABLE `empty_board`
  ADD PRIMARY KEY (`x`,`y`);

--
-- Indexes for table `full_pieces_board`
--
ALTER TABLE `full_pieces_board`
  ADD PRIMARY KEY (`x`,`y`);

--
-- Indexes for table `pieces_board`
--
ALTER TABLE `pieces_board`
  ADD PRIMARY KEY (`x`,`y`,`game_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`game_id`,`player`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
