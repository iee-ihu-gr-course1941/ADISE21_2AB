<?php

	$full=0;

	function show_board() {
		global $mysqli;

		header('Content-type: application/json');
		print json_encode(read_board(), JSON_PRETTY_PRINT);
	}

	function show_pieces_board() {
		global $mysqli;

		header('Content-type: application/json');
		print json_encode(read_pieces_board(), JSON_PRETTY_PRINT);
	}

	function read_board() {
		global $mysqli;
		$sql = 'select * from board';
		$st = $mysqli->prepare($sql);
		$st->execute();
		$res = $st->get_result();
		return($res->fetch_all(MYSQLI_ASSOC));
	}

	function read_pieces_board() {
		global $mysqli;
		$sql = 'select * from pieces_board';
		$st = $mysqli->prepare($sql);
		$st->execute();
		$res = $st->get_result();
		return($res->fetch_all(MYSQLI_ASSOC));
	}

	function reset_board() {
		global $mysqli;
		$sql = 'call clean_board()';
		$mysqli->query($sql);

	}

	function convert_board(&$orig_board) {
		$board=[];
		foreach($orig_board as $i=>&$row) {
			$board[$row['x']][$row['y']] = &$row;
		} 
		return($board);
	}

	function selectp($x,$y,$token){
		if($token==null || $token=='') {
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"token is not set."]);
			exit;
		}

		global $mysqli;
		$sql = 'call `select_piece`(?,?);';
		$st = $mysqli->prepare($sql);
		$st->bind_param('ii',$x,$y);
		$st->execute();

		header('Content-type: application/json');
		print json_encode(read_pieces_board(), JSON_PRETTY_PRINT);
	}

	function placep($x,$y,$token){
		if($token==null || $token=='') {
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"token is not set."]);
			exit;
		}

		global $mysqli;
		$sql = 'call `move_piece`(?,?);';
		$st = $mysqli->prepare($sql);
		$st->bind_param('ii',$x,$y);
		$st->execute();

		header('Content-type: application/json');
		print json_encode(read_board(), JSON_PRETTY_PRINT);

		win_condition($x,$y,$token);
	}

	function win_condition($x,$y,$token) {
		global $full;
		$full++;
		$orig_board=read_board();
		$board=convert_board($orig_board);
		$c = $board[$x][$y]['piece_color'];
		$h = $board[$x][$y]['piece_height'];
		$s = $board[$x][$y]['piece_shape'];
		$w = $board[$x][$y]['piece_hollow'];
		$sumC=0;
		$sumH=0;
		$sumS=0;
		$sumW=0;
		for($i=1; $i<5; $i++) {
			$continue = false;
			if($board[$x][$i]['piece_color']==$c) {
				$sumC++;
				$continue = true;
			}
			if($board[$x][$i]['piece_height']==$h) {
				$sumH++;
				$continue = true;
			}
			if($board[$x][$i]['piece_shape']==$s) {
				$sumS++;
				$continue = true;
			}
			if($board[$x][$i]['piece_hollow']==$w) {
				$sumW++;
				$continue = true;
			}
			if(!$continue) break;
		}

		if(!($sumC==4 || $sumH==4 || $sumS==4 || $sumW==4)) {
			$sumC=0;
			$sumH=0;
			$sumS=0;
			$sumW=0;
			for($i=1; $i<5; $i++) {
				$continue = false;
				if($board[$i][$y]['piece_color']==$c) {
					$sumC++;
					$continue = true;
				}
				if($board[$i][$y]['piece_height']==$h) {
					$sumH++;
					$continue = true;
				}
				if($board[$i][$y]['piece_shape']==$s) {
					$sumS++;
					$continue = true;
				}
				if($board[$i][$y]['piece_hollow']==$w) {
					$sumW++;
					$continue = true;
				}
				if(!$continue) break;
			}
		}

		if(!($sumC==4 || $sumH==4 || $sumS==4 || $sumW==4) && $x==$y) {
			$sumC=0;
			$sumH=0;
			$sumS=0;
			$sumW=0;
			for($i=1; $i<5; $i++) {
				$continue = false;
				if($board[$i][$i]['piece_color']==$c) {
					$sumC++;
					$continue = true;
				}
				if($board[$i][$i]['piece_height']==$h) {
					$sumH++;
					$continue = true;
				}
				if($board[$i][$i]['piece_shape']==$s) {
					$sumS++;
					$continue = true;
				}
				if($board[$i][$i]['piece_hollow']==$w) {
					$sumW++;
					$continue = true;
				}
				if(!$continue) break;
			}
		}

		if(!($sumC==4 || $sumH==4 || $sumS==4 || $sumW==4) && $x+$y==5) {
			$sumC=0;
			$sumH=0;
			$sumS=0;
			$sumW=0;
			for($i=1; $i<5; $i++) {
				$continue = false;
				if($board[$i][5-$i]['piece_color']==$c) {
					$sumC++;
					$continue = true;
				}
				if($board[$i][5-$i]['piece_height']==$h) {
					$sumH++;
					$continue = true;
				}
				if($board[$i][5-$i]['piece_shape']==$s) {
					$sumS++;
					$continue = true;
				}
				if($board[$i][5-$i]['piece_hollow']==$w) {
					$sumW++;
					$continue = true;
				}
				if(!$continue) break;
			}
		}

		if($sumC==4 || $sumH==4 || $sumS==4 || $sumW==4) {
			global $mysqli;
			$sql = 'call victory(?)';
			$st = $mysqli->prepare($sql);
			$st->bind_param('s', $token);
			$st->execute();
		}
		else if($full==16) {
			global $mysqli;
			$sql = 'call victory(?)';
			$st = $mysqli->prepare($sql);
			$st->bind_param('s', $token);
			$st->execute();
		}
	}
 
 
	

	
?>