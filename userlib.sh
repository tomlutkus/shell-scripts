#!/bin/bash

# Library: userlib.sh 
# Author: Thomas Lutkus
# Purpose: Modular user and password management library

# Generates a secure password with fallback defaults
# Usage: generate_password LENGTH UPPER LOWER NUMBERS SYMBOLS
# If called with no args, defaults to 10 char mixed password

generate_password() {
  local LENGTH="${1:-10}"
  local INCLUDE_UPPER="${2:-1}"
  local INCLUDE_LOWER="${3:-1}"
  local INCLUDE_NUMBERS="${4:-1}"
  local INCLUDE_SYMBOLS="${5:-1}"

  local UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local LOWER="abcdefghijklmnopqrstuvwxyz"
  local NUMBERS="0123456789"
  local SYMBOLS='!@#$%^&*()_+-=[]{}|;:,.<>?'

  local CHARSET=""
  local MANDATORY=""

  [[ "$INCLUDE_UPPER" -eq 1 ]] && CHARSET+="$UPPER" && MANDATORY+=${UPPER:RANDOM%${#UPPER}:1}
  [[ "$INCLUDE_LOWER" -eq 1 ]] && CHARSET+="$LOWER" && MANDATORY+=${LOWER:RANDOM%${#LOWER}:1}
  [[ "$INCLUDE_NUMBERS" -eq 1 ]] && CHARSET+="$NUMBERS" && MANDATORY+=${NUMBERS:RANDOM%${#NUMBERS}:1}
  [[ "$INCLUDE_SYMBOLS" -eq 1 ]] && CHARSET+="$SYMBOLS" && MANDATORY+=${SYMBOLS:RANDOM%${#SYMBOLS}:1}

  [[ -z "$CHARSET" ]] && { echo "Error: No character sets selected." >&2; return 1; }

  local PASS="$MANDATORY"
  while [ "${#PASS}" -lt "$LENGTH" ]; do
    PASS+="${CHARSET:RANDOM%${#CHARSET}:1}"
  done

  PASS=$(echo "$PASS" | fold -w1 | shuf | tr -d '\n')

  while [[ "$PASS" == *"." ]]; do
    PASS="${PASS:0:$((${#PASS} - 1))}${CHARSET:RANDOM%${#CHARSET}:1}"
  done

  echo "$PASS"
}

# Adds a new user with options
# Usage: add_user USERNAME COMMENT PASSWORD SUDO_FLAG SKELETON_DIR
add_user() {
  local USERNAME="$1"
  local COMMENT="$2"
  local PASSWORD="$3"
  local SUDO="$4"
  local SKELETON="$5"

  if id "$USERNAME" &>/dev/null; then
    echo "Error: User $USERNAME already exists." >&2
    return 1
  fi

  useradd -c "$COMMENT" -m -s /bin/bash "$USERNAME"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create user $USERNAME." >&2
    return 1
  fi

  echo "$USERNAME:$PASSWORD" | chpasswd
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to set password for $USERNAME." >&2
    return 1
  fi

  passwd -e "$USERNAME"

  if [[ "$SUDO" == "y" ]]; then
    usermod -aG sudo "$USERNAME"
    echo "User $USERNAME added to sudo group."
  fi

  if [[ -n "$SKELETON" && -d "$SKELETON" ]]; then
    cp -a "$SKELETON/." "/home/$USERNAME/"
    chown -R "$USERNAME:$USERNAME" "/home/$USERNAME"
  fi

  echo "User $USERNAME created with password: $PASSWORD"
}

# Parses YAML input if provided
# Usage: parse_yaml_input /path/to/file.yml
parse_yaml_input() {
  local YAML_FILE="$1"
  if ! [[ -f "$YAML_FILE" ]]; then
    echo "YAML file $YAML_FILE not found." >&2
    return 1
  fi
  eval $(awk '/:/ {gsub(/: /, "=\""); gsub(/\"$/, "\""); print "YAML_" toupper($1) "=\"" $2 "\""}' "$YAML_FILE")
}

