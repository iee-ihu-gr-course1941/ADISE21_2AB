<?php

	require_once "../lib/dbconnect.php";
	require_once "../lib/board.php";
	require_once "../lib/game.php";
	require_once "../lib/users.php";

	$method = $_SERVER['REQUEST_METHOD'];
	$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
	$input = json_decode(file_get_contents('php://input'),true);

	if($input==null) {
		$input=[];
	}
	if(isset($_SERVER['HTTP_X_TOKEN'])) {
		$input['token']=$_SERVER['HTTP_X_TOKEN'];
	} else {
		$input['token']='';
	}

	switch ($r=array_shift($request)){
		case 'board' : 
			switch ($b=array_shift($request)) {
                case '':
                case null: handle_board($method);
                            break;
				case 'place': place_piece($method,$input);
                            break;}
			break;
		case 'pieces_board' :
			switch ($b=array_shift($request)) {
                case '':
                case null: handle_pieces_board($method);
                            break;
				case 'select': select_piece($method,$input);
                            break;}
			break;
		case 'status' : 
			if(sizeof($request)==0) {show_status();}
			else {header("HTTP/1.1 404 Not Found");}
			break;
		case 'players' :handle_player($method, $request,$input);
			break;
		default: header("HTTP/1.1 404 Not Found");
			exit;
	}

	function handle_board($method) {

        if($method=='GET') {
                show_board();
        } else if ($method=='POST') {
                reset_board();
				show_board();
        }

	}

	function handle_pieces_board($method) {

        if($method=='GET') {
				show_pieces_board();
        } else if ($method=='POST') {
                reset_board();
				show_pieces_board();
        }

	}

	function handle_player($method, $p,$input) {
		switch ($b=array_shift($p)) {
			case 'A': 
			case 'B': handle_user($method, $b,$input);
				break;
			default: header("HTTP/1.1 404 Not Found");
					 print json_encode(['errormesg'=>"Player $b not found."]);
				break;
		}
	}

	function select_piece($method,$input) {
		if($method=='GET') {
			header('HTTP/1.1 405 Method Not Allowed');
		} else {
			selectp($input['x'],$input['y'],$input['token']);
		}
	}

	function place_piece($method,$input) {
		if($method=='GET') {
			header('HTTP/1.1 405 Method Not Allowed');
		} else {
			placep($input['x'],$input['y'],$input['token']);
		}
	}

	function handle_status($method) {
		if($method=='GET') {
			show_status();
		} else {
			header('HTTP/1.1 405 Method Not Allowed');
		}
	}

?>