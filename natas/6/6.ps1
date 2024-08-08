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

#this solution doesn't work, since $_POST["secret"] will return "0" and not the integer 0
#the solution is to just access the secret by typing it's path
$body = "submit=&secret=0"
$body = "submit=&secret=asdasda"

$response = Invoke-WebRequest -Method Post -Headers $headers -URI $url -Body $body
$response.COntent