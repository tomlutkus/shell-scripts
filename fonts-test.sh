#!/bin/bash

# Script: fonts-test.sh
# Author: Thomas Lutkus
# Purpose: To test drive all nerd fonts live on Kitty

FONT=$(fc-list | grep "Nerd Font" | cut -d: -f2 | sort -u | fzf)

if [[ -n "$FONT" ]]; then
  echo "font_family${FONT}" | awk '{gsub(/^[ \t]+/, ""); print}' > ~/.config/kitty/font.conf
  kill -SIGUSR1 $(pgrep -x kitty) # reload config
fi

