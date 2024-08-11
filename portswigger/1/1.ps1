. "../../scripts/GetInputFieldValueByName.ps1"

param (
    [Parameter(Mandatory = $true)]
    [string]$server,
    [Parameter(Mandatory = $true)]
    [string]$username,
    [Parameter(Mandatory = $true)]
    [string]$password
)

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

$commandurl = $url + "/login";

#get token to login
$response = iwr -URI $commandurl -SessionVariable requestSession -Method Get;  

GetInputFieldValueByName $response "csrf"
#login
#$data = @{ "csrf" = GetInputFieldValueByName $response "csrf"; "username" = "$username"; "password" = "$password" } | ConvertTo-Json
$data = "csrf=" + ( GetInputFieldValueByName $response "csrf" )+ "&username=$username&password=$password"
$response = iwr -URI $commandurl -WebSession $requestSession -Method Post -Body $data; 

$commandurl = $url + "/api/user/$username";
#$data = "csrf=" + (GetInputFieldValueByName $response "csrf") 
$response = iwr -URI $commandurl -WebSession $requestSession -Method Get # -Body $data;

write-host `n$response`n

$commandurl = $url + "/api/user/carlos";
$response = iwr -URI $commandurl -WebSession $requestSession -Method Delete
write-host `n$response`n

exit
#delete carlos
$data = @{ "csrf" = (GetInputFieldValueByName $response "csrf"); "username" = "$username"; "password" = "$password" } | ConvertTo-Json
$response = iwr -URI $commandurl -WebSession $requestSession -Method Delete -Body $data; 

