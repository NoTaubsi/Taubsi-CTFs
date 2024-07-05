import gzip
import bz2
import zipfile
import io

# Original byte array
byte_array = bytes([
    27, 232, 37, 17, 167, 186, 91, 253, 87, 140, 14, 239, 70, 109, 181, 156,
    220, 132, 114, 143, 220, 248, 157, 147, 117, 29, 16, 167, 199, 92, 140, 242,
    75, 147, 76, 93, 17, 170, 200, 135, 227, 47, 78, 69, 122, 213, 57, 111, 172,
    59, 135, 28, 28, 68, 131, 134, 180, 92, 211, 109, 158, 143, 114, 244, 101,
    81, 73, 187, 186, 33, 35, 216, 157, 149, 65, 126, 162, 127, 58, 123
])

# Function to attempt decompression with gzip
def try_gzip(byte_array):
    try:
        decompressed_data = gzip.decompress(byte_array)
        return decompressed_data
    except Exception as e:
        return f"gzip decompression failed: {e}"

# Function to attempt decompression with bz2
def try_bz2(byte_array):
    try:
        decompressed_data = bz2.decompress(byte_array)
        return decompressed_data
    except Exception as e:
        return f"bz2 decompression failed: {e}"

# Function to attempt decompression with zip
def try_zip(byte_array):
    try:
        with zipfile.ZipFile(io.BytesIO(byte_array), 'r') as zf:
            file_list = zf.namelist()
            return {name: zf.read(name) for name in file_list}
    except Exception as e:
        return f"zip decompression failed: {e}"

# Check for common file headers
def check_magic_numbers(byte_array):
    magic_numbers = {
        "JPEG": b'\xFF\xD8\xFF',
        "PNG": b'\x89\x50\x4E\x47\x0D\x0A\x1A\x0A',
        "GIF": b'GIF',
        "PDF": b'%PDF',
        "ZIP": b'PK\x03\x04',
        "GZIP": b'\x1F\x8B',
        "BZ2": b'BZh',
        "7Z": b'7z\xBC\xAF\x27\x1C'
    }
    for filetype, magic in magic_numbers.items():
        if byte_array.startswith(magic):
            return f"File type identified: {filetype}"
    return "No matching file headers found."

# Attempt decompressions
gzip_result = try_gzip(byte_array)
bz2_result = try_bz2(byte_array)
zip_result = try_zip(byte_array)
magic_number_check = check_magic_numbers(byte_array)

# Print results
print("Gzip Decompression Result:", gzip_result)
print("Bz2 Decompression Result:", bz2_result)
print("Zip Decompression Result:", zip_result)
print("Magic Number Check Result:", magic_number_check)