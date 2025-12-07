#!/usr/bin/zsh
open=$(hyprctl clients | rg "Spotify")

spotify &

while [[ -z $open ]]; do
    open=$(hyprctl clients | rg "Spotify")
    sleep 1
done

sleep 3

hyprctl dispatch closewindow "class:Spotify"
