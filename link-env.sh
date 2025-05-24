#!/bin/bash

# Script: link-env.sh
# Author: Thomas Lutkus
# Purpose: To link my dotfiles when refreshing a system

# Create config directory if missing
mkdir -p ~/.config

echo "[*] Linking config files..."

ln -sf "$HOME/env/bashrc" ~/.bashrc
ln -sf "$HOME/env/bash_profile" ~/.bash_profile

ln -sf "$HOME/env/config/kitty" ~/.config/kitty
ln -sf "$HOME/env/config/nvim" ~/.config/nvim

echo "[✓] Done."

