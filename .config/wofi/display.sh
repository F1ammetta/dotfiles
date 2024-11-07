#!/bin/bash

options="Mirror\nExtend\nOnly laptop\nOnly external"

selected_option=$(echo -e "$options" | wofi --dmenu --prompt="Screen setting" --insensitive)

case $selected_option in
    Mirror)
        hyprctl keyword monitor "eDP-1, enable"
        hyprctl keyword monitor "HDMI-A-2, enable"
        hyprctl keyword monitor "HDMI-A-2,preffered,auto,1,mirror,eDP-1"
        swww img -o HDMI-A-2 ~/Pictures/wallpaper.png
        swww img -o eDP-1 ~/Pictures/wallpaper.png
        pkill swww-daemon
        hyprctl dispatch exec swww-daemon
        ;;
    Extend)
        hyprctl keyword monitor "eDP-1, enable"
        hyprctl keyword monitor "HDMI-A-2, enable"
        hyprctl keyword monitor "HDMI-A-2,preffered,1920x0,1"
        swww img -o eDP-1 ~/Pictures/wallpaper.png
        swww img -o HDMI-A-2 ~/Pictures/wallpaper.png
        pkill swww-daemon
        hyprctl dispatch exec swww-daemon
        ;;
    "Only laptop")
        hyprctl keyword monitor "eDP-1, enable"
        hyprctl keyword monitor "HDMI-A-2, disable"
        pkill waybar
        hyprctl dispatch exec waybar
        swww img -o eDP-1 ~/Pictures/wallpaper.png
        pkill swww-daemon
        hyprctl dispatch exec swww-daemon
        ;;
    "Only external")
        hyprctl keyword monitor "eDP-1, disable"
        hyprctl keyword monitor "HDMI-A-2, enable"
        swww img -o HDMI-A-2 ~/Pictures/wallpaper.png
        pkill waybar
        hyprctl dispatch exec waybar
        pkill swww-daemon
        hyprctl dispatch exec swww-daemon
        ;;
    *)
        ;;
esac
