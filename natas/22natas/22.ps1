param (
    [string]$type
)
. "../natas_filter.ps1"

$server = "natas21.natas.labs.overthewire.org"
$serverExp = "natas21-experimenter.natas.labs.overthewire.org"

#$server = "localhost:8000"
#$serverExp = "localhost:8000"

#$url = "http://$server/21.php?debug"
#$urlExp = "http://$serverExp/21exp.php?debug"

$url = "http://$server/index.php?debug"
$urlExp = "http://$serverExp/index.php?debug"

$username = "natas21"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}
