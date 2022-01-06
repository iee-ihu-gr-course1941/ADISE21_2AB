<?php

	require_once "../lib/dbconnect.php";
	
	$sql = "select * from board";
	
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $res->fetch_result();
	$r = $res->fetch_assoc();
	print "status: $r[status], last_change: $r[last_change]";

?>