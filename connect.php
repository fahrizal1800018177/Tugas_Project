<?php

define('HOST', 'localhost');
define('USER', 'root');
define('PASS', '');
define('DB', 'project');

$con = mysqli_connect(HOST,USER,PASS,DB) or die('unable to connect');

?>