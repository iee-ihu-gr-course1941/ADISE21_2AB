var me = { token: null, give_place: null};
var game_status = {};
var board = {};
var last_update = new Date().getTime();
var timer = null;

$(function () {
	draw_empty_board();
	draw_pieces_board();
	draw_move_board();
	fill_board();
	fill_pieces_board();

	$('#pick').click(select);
	$('#place').click(place);
	$('#quarto_login').click(login_to_game);
	$('#quarto_reset').click(reset_board);
	$('#whole_move_div').hide();
	game_status_update();
});

function draw_empty_board(p) {

	if (p != 'S') { p = 'F'; }
	var draw_init = {
		'F': { i1: 1, i2: 5, istep: 1, j1: 1, j2: 5, jstep: 1 },
		'S': { i1: 1, i2: 5, istep: 1, j1: 1, j2: 5, jstep: 1 }
	};
	var s = draw_init[p];
	var t = '<table align="center" id="quarto_table">';
	for (var i = s.i1; i != s.i2; i += s.istep) {
		t += '<tr>';
		for (var j = s.j1; j != s.j2; j += s.jstep) {
			t += '<td class="square" id="square_' + i + '_' + j + '">' + '<img src="images/p-1.jpg">' + '</td>';
		}
		t += '</tr>';
	}
	t += '</table>';

	$('#quarto_board').html(t);
	$('.square').click(click_on_piece_place);
}

function draw_pieces_board(p) {

	if (p != 'S') { p = 'F'; }
	var draw_init = {
		'F': { i1: 1, i2: 3, istep: 1, j1: 1, j2: 9, jstep: 1 },
		'S': { i1: 1, i2: 3, istep: 1, j1: 1, j2: 9, jstep: 1 }
	};
	var s = draw_init[p];
	var t = '<table align="center" id="pieces_table">';
	for (var i = s.i1; i != s.i2; i += s.istep) {
		t += '<tr>';
		for (var j = s.j1; j != s.j2; j += s.jstep) {
			t += '<td class="square2" id="square2_' + i + '_' + j + '">' + '<img src="images/p-1.jpg">' + '</td>';
		}
		t += '</tr>';
	}
	t += '</table>';

	$('#pieces_board').html(t);
	$('.square2').click(click_on_piece_select);
}

function draw_move_board(p) {
	var t = '<table align="center" id="move_table"><tr><td id="move_text"></td><td id="move_piece"></td></tr></table>';
	$('#move_div').html(t);
}

function fill_board() {
	$.ajax({
		url: "quarto.php/board/",
		headers: {"X-Token": me.token},
		success: fill_board_by_data
	});
}

function reset_board() {
	$.ajax({ url: "quarto.php/board/", headers: { "X-Token": me.token }, method: 'POST', success: game_status_update});
	$('#move_div').hide();
	$('#game_initializer').show(2000);
}

function fill_pieces_board() {
	$.ajax({
		url: "quarto.php/pieces_board/",
		headers: {"X-Token": me.token},
		success: fill_pieces_board_by_data
	});
}

function fill_board_by_data(data) {
	board = data;
	for (var i = 0; i < data.length; i++) {
		var o = data[i];
		var id = '#square_' + o.x + '_' + o.y;
		var c = (o.piece_color != null) ? o.piece_color + o.piece_height + o.piece_shape + o.piece_hollow : '';
		var im = (o.piece_color != null) ? '<img src="images/' + c + '.jpg">' : '<img src="images/p-1.jpg">';
		$(id).html(im);
	}
}

function fill_pieces_board_by_data(data) {
	board = data;
	 for (var i = 0; i < data.length; i++) {
	 	o = data[i];
	 	if (o.selected == 'Y') {
	 		id = '#move_piece';
			temp_id = '#square2_' + o.x + '_' + o.y;
			$(temp_id).html('');
	 	}
	 	else {
	 		id = '#square2_' + o.x + '_' + o.y;
         }
	 	c = (o.piece_color != null) ? o.piece_color + o.piece_height + o.piece_shape + o.piece_hollow : '';
	 	im = (o.piece_color != null) ? '<img src="images/' + c + '.jpg">' : '';
	 	$(id).html(im);
	}
}

function login_to_game() {
	if ($('#username').val() == '') {
		alert('You have to set a username');
		return;
	}
	var p_turn = $('#pturn').val();
	fill_board();
	fill_pieces_board();

	$.ajax({
		url: "quarto.php/players/" + p_turn,
		method: 'PUT',
		dataType: "json",
		headers: { "X-Token": me.token },
		contentType: 'application/json',
		data: JSON.stringify( {username: $('#username').val(), player: p_turn}),
		success: login_result,
		error: login_error
	});
}

function login_result(data) {
	me = data[0];
	$('#game_initializer').hide();
	update_info();
	game_status_update();
}

function login_error(data, y, z, c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}

function update_info() {
	$('#game_info').html("I am Player: " + me.player + ", my name is " + me.username + '<br>Token=' + me.token + '<br>Game state: ' + game_status.status + ', ' + game_status.p_turn + ' must play now.');
	if (game_status.round == '2') {
		$('#move_text').html("Here's a piece for you to put on the board: ");
	}
	else {
		$('#move_text').html("Choose a piece for your opponent!");
    }
}

function game_status_update() {
	clearTimeout(timer);
	$.ajax({ url: "quarto.php/status/", success: update_status, headers: { "X-Token": me.token } });
}

function update_status(data) {
	last_update = new Date().getTime();
	var game_stat_old = game_status;
	game_status = data[0];
	update_info();
	clearTimeout(timer);
	fill_board();
	fill_pieces_board();
	if (game_status.p_turn == me.player && me.player != null) {
		x = 0;
		$('#whole_move_div').show(1000);
		if (game_status.round == '1') {
			$('#pick_div').show(1000);
			$('#place_div').hide(1000);
			$('#move_div').hide(1000);
		}
		else {
			$('#pick_div').hide(1000);
			$('#place_div').show(1000);
			$('#move_div').show(1000);
        }
		timer = setTimeout(function () { game_status_update(); }, 15000);
	} else {
		// must wait for something
		$('#whole_move_div').hide(1000);
		timer = setTimeout(function () { game_status_update(); }, 4000);
	}

}

function select() {
	var s = $('#pick_position').val();

	var a = s.trim().split(/[ ]+/);
	if (a.length != 2) {
		alert('Must give 2 numbers');
		return;
	}
	$.ajax({
		url: "quarto.php/pieces_board/select/",
		method: 'PUT',
		dataType: "json",
		contentType: 'application/json',
		data: JSON.stringify({ x: a[0], y: a[1] }),
		headers: { "X-Token": me.token },
		success: move_result2,
		error: login_error
	});

}

function place() {
	var s = $('#place_position').val();

	var a = s.trim().split(/[ ]+/);
	if (a.length != 2) {
		alert('Must give 2 numbers');
		return;
	}
	$.ajax({
		url: "quarto.php/board/place/",
		method: 'PUT',
		dataType: "json",
		contentType: 'application/json',
		data: JSON.stringify({ x: a[0], y: a[1] }),
		headers: { "X-Token": me.token },
		success: move_result,
		error: login_error
	});

}

function move_result(data) {
	game_status_update();
	fill_board_by_data(data);
}

function move_result2(data) {
	game_status_update();
	fill_pieces_board_by_data(data);
}

function click_on_piece_select(e) {
	var o = e.target;
	if (o.tagName != 'TD') { o = o.parentNode; }
	if (o.tagName != 'TD') { return; }

	var id = o.id;
	var a = id.split(/_/);
	$('#pick_position').val(a[1] + ' ' + a[2]);
	$.ajax({
		url: "quarto.php/pieces_board/select/",
		method: 'PUT',
		dataType: "json",
		contentType: 'application/json',
		data: JSON.stringify({ x: a[1], y: a[2] }),
		headers: { "X-Token": me.token },
		success: move_result2,
		error: login_error
	});
}

function click_on_piece_place(e) {
	var o = e.target;
	if (o.tagName != 'TD') { o = o.parentNode; }
	if (o.tagName != 'TD') { return; }

	var id = o.id;
	var a = id.split(/_/);
	$('#place_position').val(a[1] + ' ' + a[2]);
	$.ajax({
		url: "quarto.php/board/place/",
		method: 'PUT',
		dataType: "json",
		contentType: 'application/json',
		data: JSON.stringify({ x: a[1], y: a[2] }),
		headers: { "X-Token": me.token },
		success: move_result,
		error: login_error
	});
}

