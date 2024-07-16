<?php
// cheers and <3 to malvina
// - morla

function setLanguage()
{
    /* language setup */
    if (array_key_exists("lang", $_REQUEST)) {
        if (safeinclude("language/" . $_REQUEST["lang"]))
            return 1;
    }
    //language/../index.php
    safeinclude("language/en");
}

function safeinclude($filename)  //"language/en" "language/de" "language/myinjection"
{
    // check for directory traversal
    echo "filename: " . $filename . PHP_EOL . PHP_EOL;
    if (strstr($filename, "../")) {
        logRequest("Directory traversal attempt! fixing request.");
        $filename = str_replace("../", "", $filename);
    }

    echo "filename after ../: " . $filename . PHP_EOL;
    // dont let ppl steal our passwords
    if (strstr($filename, "natas_webpass")) {
        logRequest("Illegal file access detected! Aborting!");
        exit(-1);
    }
    echo "filename after natas_webpass: " . $filename . PHP_EOL . PHP_EOL;
    // add more checks...

    if (file_exists($filename)) {
        include ($filename);
        return 1;
    }
    return 1;
    //return 0;
}

function listFiles($path)
{
    $listoffiles = array();
    if ($handle = opendir($path)) //$handle = opendir("language/")
        while (false !== ($file = readdir($handle))) //returns: "language/$file(iterator)"
            if ($file != "." && $file != "..")
                $listoffiles[] = $file;

    closedir($handle);
    return $listoffiles;
}

function logRequest($message)
{
    echo $message . PHP_EOL;
    $log = "[" . date("d.m.Y H::i:s", time()) . "]";
    $log = $log . " " . $_SERVER['HTTP_USER_AGENT']; //yo injection here?
    $log = $log . " \"" . $message . "\"\n";
    echo "fopen append: /var/www/natas/natas25/logs/natas25_" . session_id() . ".log" . PHP_EOL;
    echo $log . PHP_EOL;
    /*
    $fd = fopen("/var/www/natas/natas25/logs/natas25_" . session_id() . ".log", "a");
    fwrite($fd, $log);
    fclose($fd);
    */
}
?>

<h1>natas25</h1>
<div id="content">
    <div align="right">
        <form>
            <select name='lang' onchange='this.form.submit()'>
                <option>language</option>
                <?php /*foreach (listFiles("language/") as $f)
               echo "<option>$f</option>"; */ ?>
            </select>
        </form>
    </div>

    <?php
    session_start();
    setLanguage();

    echo "<h2>$__GREETING</h2>";
    echo "<p align=\"justify\">$__MSG";
    echo "<div align=\"right\"><h6>$__FOOTER</h6><div>";
    ?>
    <p>
    <div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
</div>
</body>

</html>

<?php
$__MSG
    ?>


<!--
language/../../../../etc/Natas_webpass/natas26
ls 17natas/../../../../../../etc/emacs
site-start.d
-->