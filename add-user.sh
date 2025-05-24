#!/bin/bash

# Script: add-user.sh
# Author: Thomas Lutkus
# Purpose: CLI wrapper for userlib.sh

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/userlib.sh"

# Optional: parse YAML if provided
if [[ -n "$1" ]]; then
  YAML_FILE="$1"
  if [[ -f "$YAML_FILE" ]]; then
    parse_yaml_input "$YAML_FILE"
    USERNAME="$YAML_USERNAME"
    COMMENT="$YAML_COMMENT"
    PASSWORD="$YAML_PASSWORD"
    SUDO="$YAML_SUDO"
    SKELETON="$YAML_SKELETON"
  else
    echo "YAML file not found: $YAML_FILE" >&2
    exit 1
  fi
fi

# Prompt fallback if variables are still unset
[[ -z "$USERNAME" ]] && read -p "Enter the username to create: " USERNAME
[[ -z "$COMMENT" ]] && read -p "Enter the full name or comment: " COMMENT

# Ask if password should be manually entered
if [[ -z "$PASSWORD" ]]; then
  read -p "Enter password (leave empty to auto-generate): " PASSWORD
  if [[ -z "$PASSWORD" ]]; then
    PASSWORD=$(generate_password 12 1 1 1 1)
    echo "Generated password: $PASSWORD"
  fi
fi

[[ -z "$SUDO" ]] && read -p "Should the user be a sudoer? (y/n): " SUDO
[[ -z "$SKELETON" ]] && read -p "Path to skeleton directory (leave empty for default): " SKELETON

add_user "$USERNAME" "$COMMENT" "$PASSWORD" "$SUDO" "$SKELETON"

