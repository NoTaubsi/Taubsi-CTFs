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

$commandurl = $url + "/api/products/1/price";
$response = iwr -URI $commandurl -WebSession $requestSession -Method Get;
$response.Content | ConvertFrom-Json

<# {   "type": "ClientError",   "code": 400,   "error": "Only \u0027application/json\u0027 | Content-Type is supported" } #>
$commandurl = $url + "/api/products/1/price";

$data = @{"price" = 0} | ConvertTo-Json
$response = iwr -Headers $headers -URI $commandurl -WebSession $requestSession -Method Patch -Body $data;

