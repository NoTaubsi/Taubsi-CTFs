<?php

session_start();

// if update was submitted, store it
if (array_key_exists("submit", $_REQUEST)) {
    echo "Setting:" . PHP_EOL;
    foreach ($_REQUEST as $key => $val) {
        $_SESSION[$key] = $val;
        echo "\$_SESSION[$key] = $val" . PHP_EOL;
    }
    echo "". PHP_EOL;
}

if (array_key_exists("debug", $_GET)) {
    print "[DEBUG] Session contents:<br>";
    #print_r($_SESSION); 
    echo session_encode() . PHP_EOL . PHP_EOL;
}

// only allow these keys
$validkeys = array("align" => "center", "fontsize" => "100%", "bgcolor" => "yellow");
$form = "";

$form .= '<form action="index.php" method="POST">';
foreach ($validkeys as $key => $defval) {
    $val = $defval;
    echo "key: $key" . PHP_EOL;
    if (array_key_exists($key, $_SESSION)) {
        $val = $_SESSION[$key];
        echo "$val = \$_SESSION[$key]" . PHP_EOL;
    } else {
        $_SESSION[$key] = $val;
        echo "\$_SESSION[$key] = $val" . PHP_EOL;       
    }
    $form .= "$key: <input name='$key' value='$val' /><br>";
}
$form .= '<input type="submit" name="submit" value="Update" />';
$form .= '</form>';

$style = "background-color: " . $_SESSION["bgcolor"] . "; text-align: " . $_SESSION["align"] . "; font-size: " . $_SESSION["fontsize"] . ";";
echo "\$style: $style";
$example = "<div style='$style'>Hello world!</div>";

?>

<p>Example:</p>
<?= $example ?>

<p>Change example values here:</p>
<?= $form ?>

<div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
</div>
</body>

</html>