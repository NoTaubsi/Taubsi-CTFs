function FilterNatasHTML {
    param (
        [string]$responseStr 
    )
    $response = $responseStr -replace "(?s).*?<body>", ""
    $response = $response -replace "</body>(?s).*?", ""
    return $response
    #return (((($responseStr -replace "<br>", "`n") -split "`n") | Where-Object { $_ -notmatch "<|>" }) -join "`n")
}