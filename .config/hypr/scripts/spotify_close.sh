#!/usr/bin/zsh
open=$(hyprctl clients | rg "spotify")

spotify &

while [[ -z $open ]]; do
    open=$(hyprctl clients | rg "spotify")
    sleep 1
done

sleep 3

hyprctl dispatch closewindow "class:spotify"
hyprctl dispatch workspace 1
