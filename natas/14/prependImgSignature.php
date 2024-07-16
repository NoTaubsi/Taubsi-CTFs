<?php
function prependSignature($filename, $signature) {
    // Read the original file content
    $content = file_get_contents($filename);
    if ($content === false) {
        return false;
    }

    // Convert hex signature to binary
    $binarySignature = hex2bin($signature);

    // Prepend the signature to the content
    $newContent = $binarySignature . $content;

    // Write the new content back to the file
    return file_put_contents($filename, $newContent) !== false;
}

// Usage
$filename = "C:\.....\little file.php";
$signature = 'ffd8ffe0'; // JPEG signature

if (prependSignature($filename, $signature)) {
    echo "Signature added successfully.";
} else {
    echo "Failed to add signature.";
}
?>