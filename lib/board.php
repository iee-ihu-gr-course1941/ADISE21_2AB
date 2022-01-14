<?php

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
		print json_encode(read_board(), JSON_PRETTY_PRINT);
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
	}

	

	
?>