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
remove-item ".\tmp\natas26_mylog.log"
Invoke-WebRequest -Headers $headers -URI ($url + $params) -SessionVariable sessVar > $null
$phpsessid = getCookieValueFromKey -sessVar $sessVar -key "PHPSESSID"
(Invoke-WebRequest -Headers $headers -URI $url -WebSession $sessVar).Content
#FilterNatasHTML -responseStr $response
Get-Content ".\tmp\natas26_mylog.log"


#$_COOKIE["drawing"] contains base64_encode(serialize($ArrayOfXYPointers))
#serialized means: Can be read as an Object