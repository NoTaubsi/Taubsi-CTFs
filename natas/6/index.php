<?php
include "include/secret.inc";
echo $secret . PHP_EOL . "<br>";
if (array_key_exists("submit", $_POST)) {
    if ($secret == $_POST["secret"]) {
        echo "Access granted. The password for natas7 is";
    } else {
        echo "Wrong secret";
    }
}
?>