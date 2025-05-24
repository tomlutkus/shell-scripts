#!/bin/bash
set -e

# Script: clear-template.sh
# Author: Thomas Lutkus
# Purpose: To clean my Virtual Machine fresh templates

echo "[*] Cleaning cloud-init state..."
cloud-init clean --logs

echo "[*] Clearing machine-id..."
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

echo "[*] Removing SSH host keys..."
rm -f /etc/ssh/ssh_host_*

echo "[*] Removing persistent net rules..."
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "[*] Clearing system logs..."
journalctl --rotate
journalctl --vacuum-time=1s
rm -rf /var/log/cloud-init* /var/log/syslog /var/log/wtmp /var/log/btmp /var/log/auth.log

echo "[*] Removing bash history..."
unset HISTFILE
history -c
cat /dev/null > ~/.bash_history
find /root /home -name .bash_history -exec rm -f {} \;

echo "[*] Clearing APT logs and lists..."
rm -f /var/log/apt/history.log /var/log/apt/term.log
rm -rf /var/lib/apt/lists/*

echo "[*] Removing wget HSTS cache..."
rm -f ~/.wget-hsts /root/.wget-hsts

echo "[*] Removing temporary files..."
rm -rf /tmp/* /var/tmp/*

echo "[*] Removing old netplan config (if letting cloud-init manage networking)..."
rm -f /etc/netplan/*.yaml

echo "[*] Done. Ready to shut down and convert to template."

