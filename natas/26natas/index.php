<?php
// sry, this is ugly as hell.
// cheers kaliman ;)
// - morla

$logger = new Logger("mylog");
class myclass {
    public string $myprop;
    public function getContent() {
        return file_get_contents("tmp/lol.txt", false);
    }
    public function __serialize(): array {
        //echo "__serialize: " . file_get_contents("tmp/lol.txt", false) . PHP_EOL;
        $array = [];
        array_push($array, $this->getContent());
        //$this->$myprop = file_get_contents("tmp/lol.txt", false);
        return $array;
        //echo file_get_contents("etc/natas_webpass/natas27", false);
    }
    public function __unserialize(array $data): void {
        //echo "__UNserialize: " . file_get_contents("tmp/lol.txt", false)  . PHP_EOL;
        echo "vardump ";
        var_dump($data);
        echo  PHP_EOL;
        //echo file_get_contents("etc/natas_webpass/natas27", false);
    }
}
$myclass = new myclass();
$myclass->myprop = "helloMyProp";
$str = serialize($myclass);
$logger->log("myclass() serialized: " . $str);
unserialize($str);
class Logger
{
    private $logFile;
    private $initMsg;
    private $exitMsg;

    function __construct($file)
    {
        // initialise variables
        $this->initMsg = "#--session started--#\n";
        $this->exitMsg = "#--session end--#\n\n\n";
        #$this->logFile = "/tmp/natas26_" . $file . ".log";
        $this->logFile = 'tmp/natas26_' . $file . ".log";

        // write initial message
        $fd = fopen($this->logFile, "a+");
        fwrite($fd, $this->initMsg);
        fclose($fd);
    }

    function log($msg)
    {
        $fd = fopen($this->logFile, "a+");
        fwrite($fd, $msg . "\n");
        fclose($fd);
    }

    function __destruct()
    {
        // write exit message
        $fd = fopen($this->logFile, "a+");
        fwrite($fd, $this->exitMsg);
        fclose($fd);
    }
}

function showImage($filename)
{
    global $logger;
    $logger->log(" 5 - showImage");
    if (file_exists($filename)) {
        echo "<img src=\"$filename\">";
        #$logger->log(' - - echo "<img src="' . $filename . '">');
    }
}

function drawImage($filename)
{
    global $logger;
    $logger->log(" 1 - drawImage: " .$filename);
    $img = imagecreatetruecolor(400, 300);
    drawFromUserdata($img);
    imagepng($img, $filename);
    $logger->log(" 4 - - GDimagepng save to: " .$filename . " <----- you just saved a bunch of garbage from \$_COOKIE");
    imagedestroy($img);
}

function drawFromUserdata($img)
{
    global $logger;
    $logger->log(" 2 - - drawFromUserData");
    if (
        array_key_exists("x1", $_GET) && array_key_exists("y1", $_GET) &&
        array_key_exists("x2", $_GET) && array_key_exists("y2", $_GET)
    ) {
        $color = imagecolorallocate($img, 0xff, 0x12, 0x1c);
        $logger->log(" 3 - - - GD imageline(\$_GET x1 x2 y1 y2)");
        imageline($img, $_GET["x1"], $_GET["y1"], $_GET["x2"], $_GET["y2"], $color);
    }

    if (array_key_exists("drawing", $_COOKIE)) {
        $logger->log(" 3 - - - GD imageline(\$_COOKIE)");
        $drawingArray = unserialize(base64_decode($_COOKIE["drawing"]));
        if ($drawingArray)
            foreach ($drawingArray as $drawing)
                if (                                    //Can do:
                    array_key_exists("x1", $drawing) && //x1=/etc/webpass/
                    array_key_exists("y1", $drawing) && //x2=echo "hi"
                    array_key_exists("x2", $drawing) && //y1=
                    array_key_exists("y2", $drawing)
                ) {

                    $color = imagecolorallocate($img, 0xff, 0x12, 0x1c);
                    imageline(
                        $img,
                        $drawing["x1"],
                        $drawing["y1"],
                        $drawing["x2"],
                        $drawing["y2"],
                        $color
                    );

                }
    }
}

function storeData()
{
    global $logger;
    $logger->log(" 6 - storeData: Stores \$drawing object in cookie");
    $new_object = array();

    if (
        array_key_exists("x1", $_GET) && array_key_exists("y1", $_GET) &&
        array_key_exists("x2", $_GET) && array_key_exists("y2", $_GET)
    ) {
        $new_object["x1"] = $_GET["x1"];
        $new_object["y1"] = $_GET["y1"];
        $new_object["x2"] = $_GET["x2"];
        $new_object["y2"] = $_GET["y2"];
    }

    if (array_key_exists("drawing", $_COOKIE)) {
        $drawing = unserialize(base64_decode($_COOKIE["drawing"]));
    } else {
        // create new array
        $drawing = array();
    }

    $drawing[] = $new_object;
    setcookie("drawing", base64_encode(serialize($drawing)));
}
?>

<h1>natas26</h1>
<div id="content">

    Draw a line:<br>
    <form name="input" method="get">
        X1<input type="text" name="x1" size=2>
        Y1<input type="text" name="y1" size=2>
        X2<input type="text" name="x2" size=2>
        Y2<input type="text" name="y2" size=2>
        <input type="submit" value="DRAW!">
    </form>

    <?php

    session_start();

    if (array_key_exists("drawing", $_COOKIE)) {
        $logger->log("Cookie exists: " . base64_decode($_COOKIE["drawing"]));
        $logger->log(print_r(unserialize(base64_decode($_COOKIE["drawing"]))));
    } else {
        $logger->log("No Cookie: x1=" . $_GET["x1"] . ",x2=" . $_GET["x2"] . ",y1=" . $_GET["y1"] . ",y2=" . $_GET["y2"]);
    }

    if (
        array_key_exists("drawing", $_COOKIE) ||
        (array_key_exists("x1", $_GET) && array_key_exists("y1", $_GET) &&
            array_key_exists("x2", $_GET) && array_key_exists("y2", $_GET))
    ) {
        $imgfile = 'img/natas26_' . session_id() . ".png";
        drawImage($imgfile);
        showImage($imgfile);
        storeData();
    } else {
        $logger->log("failed first check");
    }

    ?>

    <div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
</div>
</body>

</html>