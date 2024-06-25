function FilterNatasHTML {
    param (
        [string]$responseStr 
    )
    return (((($responseStr -replace "<br>", "`n") -split "`n") | Where-Object { $_ -notmatch "<|>" }) -join "`n")
}