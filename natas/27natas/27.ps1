. "../natas_filter.ps1"
. "../getCookieValueFromKey.ps1"

$server = "natas27.natas.labs.overthewire.org"
$server = "localhost:8000"
$url = "http://$server"

$username = "natas27"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}



<#
--------------------------
    mysqli_real_escape_string
--------------------------
    00 = \0 (NUL)
    0A = \n
    0D = \r
    1A = ctl-Z
    22 = "
    27 = '
    5C = \
--------------------------

#>