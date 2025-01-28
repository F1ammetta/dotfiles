#!/usr/bin/zsh
open=$(hyprctl clients | rg "Spotify")

while [[ -z $open ]]; do
    open=$(hyprctl clients | rg "Spotify")
    sleep 1
done

hyprctl dispatch closewindow "^(Spotify)$"
