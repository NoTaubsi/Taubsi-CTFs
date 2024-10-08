param (
    [Parameter(Mandatory=$true)]
    [string]$server,
    [Parameter(Mandatory=$true)]
    [string]$username,
    [Parameter(Mandatory=$true)]
    [string]$password
)
$url = $server

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
} 

$commandurl = $url;
$response = Invoke-WebRequest -Headers $headers -URI $commandurl -SessionVariable responseSession;

$response = Invoke-WebRequest -Headers $headers -URI $commandurl -WebSession $responseSession

#i should use this in every of these previous levels
$filtered = ((($response.Content -replace "<br>", "`n") -split "`n") | Where-Object { $_ -notmatch "<|>" }) -join "`n"
Write-Host $filtered
<#
if ($response.Content -like "*$correctStr*") {
    write-host $response.content `n
    write-host "[admin] => 1"
    write-host "yooooo ur mum: phpSESSID: $i"
    break
}
#>