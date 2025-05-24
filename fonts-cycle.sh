#!/bin/bash

# Script: fonts-cycle.sh
# Author: Thomas Lutkus
# Purpose: To easily cycle through my favorite fonts on Kitty live

FONTS=(
  "ComicShannsMono Nerd Font Mono"
  "VictorMono Nerd Font Mono"
  "FantasqueSansMono Nerd Font Mono"
  "Mononoki Nerd Font Mono"
  "Iosevka Aile Nerd Font Mono"
)

FONT=$(printf "%s\n" "${FONTS[@]}" | fzf --prompt="Choose a terminal font: ")

if [[ -n "$FONT" ]]; then
  echo "font_family $FONT" > ~/.config/kitty/font.conf
  kill -SIGUSR1 $(pgrep -x kitty)
fi

