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

	function do_move($x,$y,$x2,$y2) {
		global $mysqli;
		$sql = 'call `move_piece`(?,?,?,?);';
		$st = $mysqli->prepare($sql);
		$st->bind_param('iiii',$x,$y,$x2,$y2 );
		$st->execute();

		header('Content-type: application/json');
		print json_encode(read_board(), JSON_PRETTY_PRINT);
	}




	
?>