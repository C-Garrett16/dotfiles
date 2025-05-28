#!/bin/bash

# GTK Theming
export GTK_THEME=Dracula
export GTK_ICON_THEME=Papirus-Dark
export QT_QPA_PLATFORMTHEME=gtk2

~/.screenlayout/default.sh

/usr/bin/emacs --daemon &

picom --config ~/.config/picom/picom.conf &
nitrogen --restore &
nm-applet &
conky -c $HOME/Projects/dotfiles/config/conky/dracula_conky.conf &
flameshot &

# Mount fileserver

# mount -t cifs -o username=cgreid@sewanee.edu password=ILoveMyAngel14 //fs.sewanee.edu/CNS /mnt/CNS
xrandr \
  --output DP-1-2 --mode 1920x1080 --pos 0x0 \
  --output DP-1-1 --mode 1920x1080 --pos 1920x0 --primary \
  --output DP-4   --mode 1920x1080 --pos 3840x0
