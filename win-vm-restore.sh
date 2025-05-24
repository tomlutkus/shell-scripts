#!/bin/bash

# Script: win-vm-restore.sh
# Author: Thomas Lutkus
# Purpose: To restore my saved Windows VM backups from the backup disk

set -euo pipefail

read -p "Enter VM name to restore: " VM_NAME

BACKUP_DIR="/mnt/drive/vm-backup/$VM_NAME/${VM_NAME}-activation-backup"
DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
DISK_SIZE="256G"

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "Backup directory not found: $BACKUP_DIR" >&2
  exit 1
fi

echo "Recreating disk image if missing..."
if [[ -f "$DISK_PATH" ]]; then
  echo "Disk image already exists at $DISK_PATH, skipping creation."
else
  sudo qemu-img create -f qcow2 "$DISK_PATH" "$DISK_SIZE"
  echo "Created blank qcow2 disk at $DISK_PATH with size $DISK_SIZE"
fi

echo "Restoring UEFI NVRAM..."
NVRAM_SRC="$BACKUP_DIR/${VM_NAME}_VARS.fd"
if [[ -f "$NVRAM_SRC" ]]; then
  sudo cp "$NVRAM_SRC" "/var/lib/libvirt/qemu/nvram/${VM_NAME}_VARS.fd"
else
  echo "Warning: No NVRAM file found in backup."
fi

echo "Restoring TPM state..."
UUID=$(grep -oP '(?<=<uuid>).*?(?=</uuid>)' "$BACKUP_DIR/${VM_NAME}.xml")
TPM_DEST="/var/lib/libvirt/swtpm/${UUID}"
sudo mkdir -p "$TPM_DEST"
sudo cp -a "$BACKUP_DIR/tpm/${UUID}"/* "$TPM_DEST/" 2>/dev/null || echo "Warning: TPM source not found or empty."

echo "Re-registering VM..."
sudo virsh define "$BACKUP_DIR/${VM_NAME}.xml"

echo "Restore complete. You can now boot the VM with:"
echo "  sudo virsh start $VM_NAME"

