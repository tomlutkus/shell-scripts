#!/bin/bash

# Script: containerbk-rotate.sh
# Author: Thomas Lutkus
# Purpose: This file-server-side script keeps container backups pruned

set -euo pipefail

TARGET_DIR="/mnt/data/containers"
RETENTION_DAYS=5

echo "[*] Processing backups under $TARGET_DIR"

for CONTAINER in "$TARGET_DIR"/*; do
  [ -d "$CONTAINER/staging" ] || continue

  echo "[*] Moving new backups for $(basename "$CONTAINER")"
  mkdir -p "$CONTAINER/daily/$(date +%F)"
  mv "$CONTAINER/staging"/*.tar.gz "$CONTAINER/daily/$(date +%F)" 2>/dev/null || true

  echo "[*] Rotating old backups"
  find "$CONTAINER/daily" -mindepth 1 -maxdepth 1 -type d | sort -r | tail -n +$((RETENTION_DAYS + 1)) | xargs -r rm -rf
done

echo "[+] Rotation complete."

