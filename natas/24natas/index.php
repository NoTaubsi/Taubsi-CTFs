Password:
<form name="input" method="get">
    <input type="text" name="passwd" size=20>
    <input type="submit" value="Login">
</form>

<?php
if (array_key_exists("passwd", $_REQUEST)) {
    // Returns -1 if string1 is less than string2; 1 if string1 is greater than string2, and 0 if they are equal. 
    // -1 = TRUE
    // 0 = FALSE
    // 1 = TRUE
    //not a real pw
    echo '$passwd:' . $_REQUEST["passwd"];
    //$test = array(); <- :)
    if (strcmp($_REQUEST["passwd"], "MeuqmfJ8DDKuKc5pcvzFKSwlxedZYEWd")) {
    //if (strcmp($test, "MeuqmfJ8DDKuKc5pcvzFKSwlxedZYEWd")) {
        echo "<br>Wrong!<br>";
    } else {
        echo "<br>The credentials for the next level are:<br>";
        echo "<pre>Username: natas25 Password: <censored></pre>";
    }
    /*
           if(!strcmp($_REQUEST["passwd"],"<censored>")){
               echo "<br>The credentials for the next level are:<br>";
               echo "<pre>Username: natas25 Password: <censored></pre>";
           }
           else{
               echo "<br>Wrong!<br>";
           } */
}
// morla / 10111

?>


<div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
</div>
</body>

</html>