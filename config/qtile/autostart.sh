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
conky &
flameshot &

# Mount fileserver

# mount -t cifs -o username=cgreid@sewanee.edu password=ILoveMyAngel14 //fs.sewanee.edu/CNS /mnt/CNS
