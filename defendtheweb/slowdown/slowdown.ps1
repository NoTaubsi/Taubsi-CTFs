param (
    [Parameter(Mandatory = $true)]
    [string]$phpSessID,
    [Parameter(Mandatory = $true)]
    [string]$rum_sid
)
. "../natas_filter.ps1"

$headers = @{
    "Accept-Encoding"  = "br"
    #can make cookie here btw
    #"Cookie" = "PHPSESSID=" + $phpSessID + ";__rum_sid=" + $rum_sid
} 

$url = "https://defendtheweb.net/playground/slow-things-down";

$cookieContainer = New-Object System.Net.CookieContainer

$cookie = New-Object System.Net.Cookie("PHPSESSID", $phpSessID, "/", "defendtheweb.net");
$cookieContainer.Add($cookie)

$cookie = New-Object System.Net.Cookie("__rum_sid", $rum_sid, "/", "defendtheweb.net");
$cookieContainer.Add($cookie)
    
$requestSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$requestSession.Cookies = $cookieContainer;

$commandurl = $url;
$response = Invoke-WebRequest -Headers $headers -URI $commandurl -WebSession $requestSession;

#$response.Headers

$token = $response.Content -split "`n" | Select-String -Pattern '<input type="hidden" name="token" id="token"'

write-host `n$token`n