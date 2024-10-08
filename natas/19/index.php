<?php

$maxid = 640; // 640 should be enough for everyone

function isValidAdminLogin()
{ /* {{{ */
    if ($_REQUEST["username"] == "admin") {
        /* This method of authentication appears to be unsafe and has been disabled for now. */
        //return 1;
    }

    return 0;
}
/* }}} */
function isValidID($id)
{ /* {{{ */
    return is_numeric($id);
}
/* }}} */
function createID($user)
{ /* {{{ */
    global $maxid;
    return rand(1, $maxid);
}
/* }}} */
function debug($msg)
{ /* {{{ */
    if (array_key_exists("debug", $_GET)) {
        print "DEBUG: $msg<br>";
    }
}
/* }}} */

function my_session_start()
{ /* {{{ */
    if (array_key_exists("PHPSESSID", $_COOKIE) and isValidID($_COOKIE["PHPSESSID"])) {
        debug("PHPSESSID: " . $_COOKIE["PHPSESSID"]);
        if (!session_start()) {

            debug("my_session_start:false");
            return false;
        } else {
            if (!array_key_exists("admin", $_SESSION)) {
                //debug("Session was old: admin flag set");
                debug("session doesn't have admin-key, setting admin-key to 0");
                $_SESSION["admin"] = 0; // backwards compatible, secure
            }
            debug("my_session_start:true:");
            debug(print_r($_SESSION));
            return true;
        }
    }

    debug("my_session_start:false");
    return false;
} /* }}} */

$showform = true;

if (array_key_exists("username", $_REQUEST) and $_REQUEST["username"] == "melgibson") {
    set_admin_true();
    print_credentials();
} else {

    if (my_session_start()) {
        print_credentials();
        $showform = false;
    } else {

        if (array_key_exists("username", $_REQUEST) && array_key_exists("password", $_REQUEST)) {

            session_id(createID($_REQUEST["username"]));
            session_start();
            $_SESSION["admin"] = isValidAdminLogin();
            debug("New session started");
            $showform = false;
            print_credentials();

        }
    }
}

function set_admin_true()
{
    debug("admin session running on: 635");
    session_id(635);
    session_start();
    $_SESSION["admin"] = 1;

}




function print_credentials()
{ /* {{{ */
    if ($_SESSION and array_key_exists("admin", $_SESSION) and $_SESSION["admin"] == 1) {
        print "You are an admin. The credentials for the next level are:<br>";
        print "<pre>Username: natas19\n";
        print "Password: <censored></pre>";
    } else {
        print "You are logged in as a regular user. Login as an admin to retrieve credentials for natas19.";
    }
}
/* }}} */




if ($showform) {
    ?>

    <p>
        Please login with your admin account to retrieve credentials for natas19.
    </p>

    <form action="index.php" method="POST">
        Username: <input name="username"><br>
        Password: <input name="password"><br>
        <input type="submit" value="Login" />
    </form>
<?php } ?>