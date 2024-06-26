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