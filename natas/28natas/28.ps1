using namespace System.Collection.Generic
using namespace Microsoft.PowerShell.Utility
using namespace uri

param (
    [int]$fillFirstLine,
    [int]$appendFullLines,
    [int]$additionalAs
)
. "../natas_filter.ps1"
. "../getCookieValueFromKey.ps1"



$server = "natas28.natas.labs.overthewire.org/"
#$server = "localhost:8000"
$url = "http://$server"

$username = "natas28"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}

write-host `n
$unknownline = '?' * 16
write-host $unknownline
write-host $unknownline

if ($fillFirstLine -gt 0) {
    $a = 'a' * $fillFirstLine
    write-host "??????$a" 
}
$a += ('a' * 16) * $appendFullLines
for ($i = 1; $i -le $appendFullLines; $i++) {
    Write-Host "aaaaaaaaaaaaaaaa - 16x:a"
}




if ($additionalAs -gt 0) {
    $bla = 'a' * $additionalAs
    $a += $bla 
    $blabla = $bla+$unknownline.Substring($additionalAs)
    write-host $blabla
} else {
    write-host $unknownline;
}

write-host $unknownline

write-host `n

<#
1B E8 25 11 A7 BA 5B FD 57 8C 0E EF 46 6D B5 9C                            = 36 pre-string
DC 84 72 8F DC F8 9D 93 75 1D 10 A7 C7 5C 8C F2

C0 87 2D EE 8B C9 0B 11 56 91 3B 08 A2 23 A3 9E #<- 4*pre-string chars, 12*'a'

B3 90 38 C2 8D F7 9B 65 D2 61 51 DF 58 F7 EA A3 #<- 16*'a'
B3 90 38 C2 8D F7 9B 65 D2 61 51 DF 58 F7 EA A3 #<- 16*'a'

CE 82 A9 55 3B 65 B8 12 80 FB 6D 3B F2 90 0F 47 #2*'a' && 14*after-string char       = 30 after-string
75 FD 50 44 FD 06 3D 26 F6 BB 7F 73 4B 41 C8 99 #16*after-string char
#>

$checkbytearray = [byte]0x01..[byte]0xFF
$formData = "?query=$a"
try {
    Invoke-WebRequest -Headers $headers -URI ($url + $formdata) -MaximumRedirection 0 -ErrorVariable errorr -ErrorAction SilentlyContinue
}
catch {
    $str = $errorr[0].InnerException.Response.Headers.Location.OriginalString
    $base64 = [uri]::UnescapeDataString($str.Substring(18))

    $bytearray = [System.Convert]::FromBase64String($base64)
    $hex = $bytearray | Format-Hex
    $i = 0;
    foreach ($line in ($hex.HexBytes -split "`n")) {
        switch ($i) {
            3 { Write-Host `n }
            (3 + $appendFullLines) { Write-Host `n }
            Default {}
        }
        if ($line -like "B3 90 38 C2 8D F7 9B 65 D2 61 51 DF 58 F7 EA A3") {
            write-host $line " = aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa"
        }
        else {
            write-host $line 
        }
        
        $i += 1;
    }
} 


<#
$URLencoded = 'G+glEae6W/1XjA7vRm21nNyEco/c+J2TdR0Qp8dcjPLAhy3ui8kLEVaROwiiI6Oes5A4wo33m2XSYVHfWPfqo7OQOMKN95tl0mFR31j36qOzkDjCjfebZdJhUd9Y9+qjs5A4wo33m2XSYVHfWPfqo7OQOMKN95tl0mFR31j36qOzkDjCjfebZdJhUd9Y9+qjs5A4wo33m2XSYVHfWPfqo7OQOMKN95tl0mFR31j36qOzkDjCjfebZdJhUd9Y9+qjs5A4wo33m2XSYVHfWPfqo7OQOMKN95tl0mFR31j36qOzkDjCjfebZdJhUd9Y9+qjs5A4wo33m2XSYVHfWPfqo7OQOMKN95tl0mFR31j36qOzkDjCjfebZdJhUd9Y9+qjs5A4wo33m2XSYVHfWPfqo7TtoIfTwL6ivtwbYUC54uvKjPTmEJE6uuOaBnYZIEpa'
$shawty = [uri]::($URLencoded)
$shawty
$bytearray = [System.Convert]::FromBase64String($shawty)


$hexString = "1b e8 25 11 a7 ba 5b fd 57 8c 0e ef 46 6d b5 9c dc 84 72 8f dc f8 9d 93 75 1d 10 a7 c7 5c 8c f2 c0 87 2d ee 8b c9 0b 11 56 91 3b 08 a2 23 a3 9e b3 90 38 c2 8d f7 9b 65 d2 61 51 df 58 f7 ea a3 b3 90 38 c2 8d f7 9b 65 d2 61 51 df 58 f7 ea a3 1f 74 71 4d 76 fc c5 d4 64 c6 a2 21 e6 ed 98 e4 62 23 a1 4d 9c 42 91 b9 87 75 b0 3f bc 73 d4 ed d8 ae 51 d7 da 71 b2 b0 83 d9 19 a0 d7 b8 8b 98"
$hexString = $hexString -replace " ", ""

$bytes = for ($i = 0; $i -lt $hexString.Length; $i += 2) {
    [Convert]::ToByte($hexString.Substring($i, 2), 16)
}

$filepath = 'C:\Users\Francisco\Desktop\OTW\natas\28natas\tmp\fileasdasd.bin'
if (Test-Path $FilePath) {
    remove-item -Path $FilePath
    "removed"
}

    #Create a new file
    New-Item -Path $FilePath
    Write-host "New File '$FilePath' Created!" -f Green

[System.IO.File]::WriteAllBytes($filepath, $bytes)
#>


<#
exit
$param = "?username=natas27$s&password=hi"
$param
(Invoke-WebRequest -Headers $headers -URI ($url + $param)  -SessionVariable sessVar).Content

$param = "?username=natas27 &password=hi"
(Invoke-WebRequest -Headers $headers -URI ($url + $param) -WebSession $sessVar).Content



'A' base64




#>
write-host `n