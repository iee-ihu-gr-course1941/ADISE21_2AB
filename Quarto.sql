-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 15, 2022 at 07:28 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `quarto`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_board` ()  BEGIN
REPLACE INTO board SELECT * FROM empty_board;
DELETE FROM `players`;
UPDATE `game_status` SET `status`='not active', `p_turn`=null, `result`=null;
REPLACE INTO pieces_board SELECT * FROM full_pieces_board;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `move_piece` (IN `x2` TINYINT, IN `y2` TINYINT)  BEGIN
DECLARE p_height, p_color, p_shape, p_hollow CHAR;
SELECT piece_height, piece_color, piece_shape, piece_hollow INTO p_height, p_color, p_shape, p_hollow
FROM `pieces_board` WHERE selected='Y';
UPDATE board
SET piece_height=p_height, piece_color=p_color, piece_shape=p_shape, piece_hollow=p_hollow
WHERE X=x2 AND Y=y2;
UPDATE pieces_board
SET selected='N',piece_height=NULL,piece_color=NULL,piece_shape=NULL,piece_hollow=NULL
WHERE selected='Y';
update game_status set round=IF(round='1','2','1');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_piece` (IN `x1` TINYINT, IN `y1` TINYINT)  BEGIN
UPDATE pieces_board
SET selected='Y'
WHERE X=x1 AND Y=y1;
update game_status set p_turn=if(p_turn='A','B','A'),round=IF(round='1','2','1');
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
  `selected` enum('Y','N') NOT NULL DEFAULT 'N',
  `game_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `full_pieces_board`
--

INSERT INTO `full_pieces_board` (`x`, `y`, `piece_color`, `piece_height`, `piece_shape`, `piece_hollow`, `selected`, `game_id`) VALUES
(1, 1, 'W', 'T', 'S', 'N', 'N', 0),
(1, 2, 'W', 'T', 'S', 'Y', 'N', 0),
(1, 3, 'W', 'S', 'S', 'N', 'N', 0),
(1, 4, 'W', 'S', 'S', 'Y', 'N', 0),
(1, 5, 'W', 'T', 'C', 'N', 'N', 0),
(1, 6, 'W', 'T', 'C', 'Y', 'N', 0),
(1, 7, 'W', 'S', 'C', 'N', 'N', 0),
(1, 8, 'W', 'S', 'C', 'Y', 'N', 0),
(2, 1, 'B', 'T', 'S', 'N', 'N', 0),
(2, 2, 'B', 'T', 'S', 'Y', 'N', 0),
(2, 3, 'B', 'S', 'S', 'N', 'N', 0),
(2, 4, 'B', 'S', 'S', 'Y', 'N', 0),
(2, 5, 'B', 'T', 'C', 'N', 'N', 0),
(2, 6, 'B', 'T', 'C', 'Y', 'N', 0),
(2, 7, 'B', 'S', 'C', 'N', 'N', 0),
(2, 8, 'B', 'S', 'C', 'Y', 'N', 0);

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
  `round` enum('1','2') DEFAULT NULL,
  `result` enum('A','B','D') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `game_status`
--

INSERT INTO `game_status` (`status`, `p_turn`, `round`, `result`, `last_change`) VALUES
('not active', NULL, '2', NULL, '2022-01-15 18:27:06');

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
  `selected` enum('Y','N') NOT NULL DEFAULT 'N',
  `game_id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pieces_board`
--

INSERT INTO `pieces_board` (`x`, `y`, `piece_color`, `piece_height`, `piece_shape`, `piece_hollow`, `selected`, `game_id`) VALUES
(1, 1, 'W', 'T', 'S', 'N', 'N', 0),
(1, 2, 'W', 'T', 'S', 'Y', 'N', 0),
(1, 3, 'W', 'S', 'S', 'N', 'N', 0),
(1, 4, 'W', 'S', 'S', 'Y', 'N', 0),
(1, 5, 'W', 'T', 'C', 'N', 'N', 0),
(1, 6, 'W', 'T', 'C', 'Y', 'N', 0),
(1, 7, 'W', 'S', 'C', 'N', 'N', 0),
(1, 8, 'W', 'S', 'C', 'Y', 'N', 0),
(2, 1, 'B', 'T', 'S', 'N', 'N', 0),
(2, 2, 'B', 'T', 'S', 'Y', 'N', 0),
(2, 3, 'B', 'S', 'S', 'N', 'N', 0),
(2, 4, 'B', 'S', 'S', 'Y', 'N', 0),
(2, 5, 'B', 'T', 'C', 'N', 'N', 0),
(2, 6, 'B', 'T', 'C', 'Y', 'N', 0),
(2, 7, 'B', 'S', 'C', 'N', 'N', 0),
(2, 8, 'B', 'S', 'C', 'Y', 'N', 0);

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_nopad_ci DEFAULT NULL,
  `player` enum('A','B') NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `last_action` timestamp NULL DEFAULT NULL
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
  ADD PRIMARY KEY (`player`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
