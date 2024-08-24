#!/bin/bash

options="Shutdown\nReboot\nSuspend\nLogout"

selected_option=$(echo -e "$options" | wofi --dmenu --prompt="Power Menu" --insensitive)

case $selected_option in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    *)
        ;;
esac

