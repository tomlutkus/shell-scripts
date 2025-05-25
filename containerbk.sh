#!/bin/bash

# Script: containerbk.sh
# Author: Thomas Lutkus
# Purpose: This script backs up a container from container/*.env

set -euo pipefail

CONFIG_FILE="${1:-}"
[ -z "$CONFIG_FILE" ] && echo "Usage: $0 <config-file>" && exit 1

# 🔌 This line loads variables from the .env file
source "$CONFIG_FILE"

# Now the script can use the values:
# - $CONTAINER_NAME
# - $VOLUME_PATH
# - $EXCLUDE_PATTERNS
# - $REMOTE_HOST
# - $REMOTE_PATH

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="${CONTAINER_NAME}_backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="/tmp/$ARCHIVE_NAME"

echo "[*] Creating backup archive for $CONTAINER_NAME..."
tar -czf "$ARCHIVE_PATH" $EXCLUDE_PATTERNS "$VOLUME_PATH"

echo "[*] Transferring backup to $REMOTE_HOST..."
rsync -av --remove-source-files "$ARCHIVE_PATH" "${REMOTE_HOST}:${REMOTE_PATH}/staging/"

echo "[+] Done."

