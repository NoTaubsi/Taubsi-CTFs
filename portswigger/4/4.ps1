param (
    [Parameter(Mandatory = $true)]
    [string]$server,
    [Parameter(Mandatory = $true)]
    [string]$username,
    [Parameter(Mandatory = $true)]
    [string]$password
)

. "../../scripts/GetInputFieldValueByName.ps1"

if ($server.EndsWith("/")) {
    $server = $server.Substring(0, $server.Length - 1)
}

if ($server.startsWith("https://")) {
    $url = $server;
} 
else {
    Write-Host `n"Wrong Server Format"`n
    exit
}

$headers = @{
    "Content-Type" = "application/json"
}

$commandurl = $url + "/login";

#get token to login
$response = iwr -URI $commandurl -SessionVariable requestSession -Method Get;

$data = "csrf=" + ( GetInputFieldValueByName $response "csrf" ) + "&username=$username&password=$password"
$response = iwr -URI $commandurl -WebSession $requestSession -Method Post -Body $data;

$commandurl = $url + "/cart"
$data = "productId=1&redir=PRODUCT&quantity=1"
$response = iwr -URI $commandurl -WebSession $requestSession -Method Post -Body $data;
