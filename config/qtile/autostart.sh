#!/bin/bash


~/.screenlayout/default.sh

/usr/bin/emacs --daemon &

picom --config ~/.config/picom/picom.conf &
nitrogen --restore &
nm-applet &
conky &
flameshot &
