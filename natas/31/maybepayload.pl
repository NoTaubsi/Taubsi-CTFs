my $file_path = '/path/to/your/file.txt';

# Open the file for reading
open(my $fh, '<', $file_path) or die "Cannot open file '$file_path' for reading: $!";

# Read the entire content of the file
my $file_content = do { local $/; <$fh> };

# Close the file handle
close($fh);

print $file_content;