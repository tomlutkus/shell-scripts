#!/bin/bash

# Script: intune-agent.sh
# Author: Thomas Lutkus
# Purpose: To start the intune agent inside Distrobox and stay compliant

set -euo pipefail

DEFAULT_CONTAINER="fedora-it"
CONTAINER_NAME="${1:-$DEFAULT_CONTAINER}"

echo "[*] Entering container: $CONTAINER_NAME"

if ! command -v distrobox >/dev/null 2>&1; then
  echo "[!] Error: 'distrobox' not found in PATH" >&2
  exit 1
fi

distrobox enter "$CONTAINER_NAME" -- bash -c '
  echo "[*] Restarting Intune services in background..."
  setsid systemctl --user restart com.microsoft.autopilot.service >/dev/null 2>&1 &
  setsid systemctl --user restart com.microsoft.intune.service >/dev/null 2>&1 &
  disown -a
  echo "[+] Restart commands dispatched"
'

