<?php

	require_once "../lib/dbconnect.php";
	
	$sql = "select * from game_status";
	
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $res->get_result();
	$r = $res->fetch_assoc();
	print "status: $r[status], last_change: $r[last_change]";

?>