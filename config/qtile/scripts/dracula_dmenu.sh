#!/bin/bash

# Manually lock to your primary monitor: 2560x1440
SCREEN_WIDTH=2560
DMENU_WIDTH=$(( SCREEN_WIDTH * 60 / 100 ))
DMENU_X=$(( (SCREEN_WIDTH - DMENU_WIDTH) / 2 ))

dmenu_path | dmenu \
  -x "$DMENU_X" -y 17 -z "$DMENU_WIDTH" -l 5 -h 38 \
  -fn "JetBrainsMono Nerd Font-11" \
  -nb "#282a36" -nf "#f8f8f2" \
  -sb "#44475a" -sf "#f8f8f2" \
  -p " " | xargs -r sh -c

