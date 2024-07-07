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
        private $filename = "";
        private $signature = 'adeafbadbabec0dedabada55ba55d00d';
        private $init = False;

        function __construct()
        {
            //$this->filename = $_POST["filename"];
            $this->signature = "a298087bdc62c917696d22cd9649c0fc";
            $this->filename = "upload1.php";
            if (filesize($_FILES['uploadedfile']['tmp_name']) > 4096) {
                echo "File is too big<br>";
            } else {                                                                //           ../../../../../natas33/upload/myownlittleindex.php
                if (move_uploaded_file($_FILES['uploadedfile']['tmp_name'], "/natas33/upload/" . $this->filename)) {
                    echo "The update has been uploaded to: /natas33/upload/$this->filename<br>";
                    echo "Firmware upgrad initialised.<br>";
                } else {
                    echo "There was an error uploading the file, please try again!<br>";
                }
            }
        }

        function __destruct()
        {
            // upgrade firmware at the end of this script
    
            // "The working directory in the script shutdown phase can be different with some SAPIs (e.g. Apache)."
            chdir("/natas33/upload/");
            if (md5_file($this->filename) == $this->signature) {
                echo "Congratulations! Running firmware update: $this->filename <br>";
                passthru("php " . $this->filename);
            } else {
                echo "Failur! MD5sum mismatch!<br>";
            }
            echo "<br>__destruct<br>";
        }
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
        echo md5_file("phar://test.phar/test.txt") . '<br>';

        exit;
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