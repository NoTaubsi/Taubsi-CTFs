#!/bin/bash

text=$(cat $1)
length=${#text}

for ((i = 0; i < length; i++)); do
    char="${text:i:1}"
    intChar=$(printf "%d" "'$char")
    rotDecryptedInt=$((intChar - 13))
    if ((rotDecryptedInt < 65)) then
        rotDecryptedInt=$((rotDecryptedInt + 26))
    fi
    decryptedChar=$(printf "\\$(printf '%03o' "$rotDecryptedInt")")
    echo -e "$decryptedChar\n"
done