#!/bin/bash

# Script: win-vm-backup.sh
# Author: Thomas Lutkus
# Purpose: To backup my Windows 11 VM, including the unique hardware id

set -euo pipefail

read -p "Enter the VM name: " VM_NAME
BACKUP_ROOT="/mnt/drive/vm-backup/$VM_NAME"
BACKUP_DIR="$BACKUP_ROOT/${VM_NAME}-activation-backup"

mkdir -p "$BACKUP_DIR/tpm"

echo "Backing up domain XML..."
sudo virsh dumpxml "$VM_NAME" > "$BACKUP_DIR/${VM_NAME}.xml"

echo "Backing up UEFI NVRAM..."
sudo cp -f "/var/lib/libvirt/qemu/nvram/${VM_NAME}_VARS.fd" "$BACKUP_DIR/"

echo "Backing up TPM state..."
UUID=$(sudo virsh dumpxml "$VM_NAME" | grep -oP '(?<=<uuid>).*?(?=</uuid>)')
TPM_SRC="/var/lib/libvirt/swtpm/${UUID}"
TPM_DEST="$BACKUP_DIR/tpm/"

if [ -d "$TPM_SRC" ]; then
  sudo rm -rf "$TPM_DEST"
  sudo cp -a "$TPM_SRC" "$TPM_DEST"
else
  echo "Warning: TPM directory not found for UUID $UUID"
fi

echo "Backup complete at: $BACKUP_DIR"
