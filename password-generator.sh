#!/bin/bash

# Script: password-generator.sh 
# Author: Thomas Lutkus
# Purpose: Wrapper around generate_password from userlib.sh

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/userlib.sh"

read -p "Password length (default 16): " LENGTH
read -p "Include uppercase? (y/n, default y): " UPPER
read -p "Include lowercase? (y/n, default y): " LOWER
read -p "Include numbers? (y/n, default y): " NUMBERS
read -p "Include symbols? (y/n, default y): " SYMBOLS

LENGTH="${LENGTH:-16}"
INCLUDE_UPPER=$([[ "$UPPER" =~ ^[Nn]$ ]] && echo 0 || echo 1)
INCLUDE_LOWER=$([[ "$LOWER" =~ ^[Nn]$ ]] && echo 0 || echo 1)
INCLUDE_NUMBERS=$([[ "$NUMBERS" =~ ^[Nn]$ ]] && echo 0 || echo 1)
INCLUDE_SYMBOLS=$([[ "$SYMBOLS" =~ ^[Nn]$ ]] && echo 0 || echo 1)

PASSWORD=$(generate_password "$LENGTH" "$INCLUDE_UPPER" "$INCLUDE_LOWER" "$INCLUDE_NUMBERS" "$INCLUDE_SYMBOLS")
echo "Generated password: $PASSWORD"
