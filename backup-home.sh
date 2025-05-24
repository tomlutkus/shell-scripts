#!/bin/bash

# Script: backup-home.sh
# Author: Thomas Lutkus
# Purpose: To backup my home folder every week

set -euo pipefail

# Config
SRC_HOME="$HOME"
SRC_MEDIA="$HOME/media"
DEST_HOME="/mnt/drive/zenith"
DEST_MEDIA="/mnt/drive/media"
DATE=$(date +%Y%m%d)
BACKUP_NAME="home-backup-$DATE"
BACKUP_PATH="$DEST_HOME/$BACKUP_NAME"

# Files/folders to back up
ITEMS=(
  ".bash_profile"
  ".bashrc"
  "code"
  "docs"
  "env"
  ".gitconfig"
  "obsidian"
  ".ssh"
)

echo "Creating home backup: $BACKUP_PATH"

mkdir -p "$BACKUP_PATH"

for item in "${ITEMS[@]}"; do
  if [ -e "$SRC_HOME/$item" ]; then
    cp -a "$SRC_HOME/$item" "$BACKUP_PATH/"
  else
    echo "Warning: $item not found, skipping"
  fi
done

# Rotate old backups — keep only the 4 most recent
echo "Pruning old backups in $DEST_HOME"
cd "$DEST_HOME"
ls -d home-backup-* 2>/dev/null | sort -r | tail -n +5 | xargs -r rm -rf

# Sync media folder
echo "Syncing media folder..."
rsync -av --delete "$SRC_MEDIA/" "$DEST_MEDIA/"

echo "Backup completed."

