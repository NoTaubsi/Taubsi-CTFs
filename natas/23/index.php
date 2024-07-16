Password:
<form name="input" method="get">
    <input type="text" name="passwd" size=20>
    <input type="submit" value="Login">
</form>

<!--
strstr
Version 	Beschreibung
8.0.0 	needle akzeptiert nun eine leere Zeichenkette.
8.0.0 	Die Übergabe eines Integer als needle wird nicht mehr unterstützt.
7.3.0 	Die Übergabe eines Integer als needle wird missbilligt.

Solution: 11iloveyou
-->

<?php
if (array_key_exists("passwd", $_REQUEST)) {
    //echo "asdasdas" . $_REQUEST["passwd"] . PHP_EOL;
    //echo strstr($_REQUEST["passwd"], "iloveyou") . PHP_EOL;
    if (strstr($_REQUEST["passwd"], "iloveyou") && ($_REQUEST["passwd"] > 10)) {
        echo "<br>The credentials for the next level are:<br>";
        echo "<pre>Username: natas24 Password: <censored></pre>";
    } else {
        echo "<br>Wrong!<br>";
    }
}
// morla / 10111
?>