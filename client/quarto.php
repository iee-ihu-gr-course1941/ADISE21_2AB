<?php

	require_once "lib/dbconnect.php";
	require_once "lib/board.php";
	require_once "lib/game.php";
	require_once "lib/users.php";

	$method = $_SERVER['REQUEST_METHOD'];
	$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
	$input = json_decode(file_get_contents('php://input'),true);

	switch ($r=array_shift($request)){
		case 'board' : 
			switch ($b=array_shift($request)) {
                case '':
                case null: handle_board($method);
                            break;
				case 'position': handle_piece($request[0],$request[1],$input);
                            break;}
			break;
		case 'pieces_board' :
			switch ($b=array_shift($request)) {
                case '':
                case null: handle_board($method);
                            break;
				case 'piece': handle_piece($request[0],$request[1],$input);
                            break;}
			break;
		case 'status' : 
			if(sizeof($request)==0) {show_status();}
			else {header("HTTP/1.1 404 Not Found");}
			break;
		case 'players' :
			break;
		default: header("HTTP/1.1 404 Not Found");
			exit;
	}

	function handle_board($method) {

        if($method=='GET') {
                show_board();
				show_pieces_board();
        } else if ($method=='POST') {
                reset_board();
				show_board();
				show_pieces_board();
        }

}

	function handle_piece($x,$y,$input) {
		move_piece($x,$y,$input['x'],$input['y'],$input['token']); 
	}

	function handle_status($method) {
		if($method=='GET') {
			show_status();
		} else {
			header('HTTP/1.1 405 Method Not Allowed');
		}
	}

?>