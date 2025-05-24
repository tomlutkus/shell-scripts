#!/bin/bash

# Script: ozone-wayland.sh
# Author: Thomas Lutkus
# Purpose: To change application shortcuts to launch them in Wayland mode

# Check that only one argument is provided
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 /path/to/application.desktop"
	exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
	echo "File not found: $1"
	exit 1
fi

# Append parameters to the Exec line
while IFS= read -r line; do
	if [[ "$line" == Exec=* ]]; then
		echo "${line} --enable-features=UseOzonePlatform --ozone-platform=wayland"
	else
		echo "$line"
	fi
done < "$1" > "$1.tmp"

# Replace the original file with the modified one
mv "$1.tmp" "$1"

echo "Parameters added to $1"
