<?php
function getImageSignature($filename, $bytes = 8) {
    $handle = fopen($filename, 'rb');
    if ($handle === false) {
        return false;
    }
    
    $signature = fread($handle, $bytes);
    fclose($handle);
    
    return bin2hex($signature);
}

// Usage
$filename = "C:\.....\DSC2721.JPG";
$signature = getImageSignature($filename);
echo $signature;
?>
