<?php
#$query = "SELECT * from users where username=\"". "natas14\"" . " and password=\"". "\"; SELECT * FROM Users WHERE username=\"natas14\"";
$query = "SELECT * from users where username=\"".$_REQUEST["username"]."\" and password=\"  \" OR 1=1 OR \"\"=\"";
$query .= "\"";
echo $query;
?>
