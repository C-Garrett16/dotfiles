#!/bin/bash

chosen=$(printf "Shutdown\nReboot\nLock\nLogout\nSuspend" | rofi -dmenu -i -theme ~/.config/rofi/themes/dracula-powermenu.rasi -p "Power")

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Lock) i3lock -c 000000 ;;
    Logout) kill -SIGTERM $(pgrep -u $USER qtile) ;;
    Suspend) systemctl suspend ;;
esac
