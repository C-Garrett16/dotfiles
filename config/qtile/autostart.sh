#!/bin/bash


~/.screenlayout/default.sh

/usr/bin/emacs --daemon &

picom --config ~/.config/picom/picom.conf &
nitrogen --restore &
nm-applet &
conky &
flameshot &

# Mount fileserver

# mount -t cifs -o username=cgreid@sewanee.edu password=ILoveMyAngel14 //fs.sewanee.edu/CNS /mnt/CNS
