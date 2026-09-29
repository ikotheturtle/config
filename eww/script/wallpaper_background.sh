#!/bin/bash

# matikan semua wallpaper lama
pkill swaybg
pkill mpvpaper

# jalanin wallpaper baru
setsid bash /home/iko/.config/waybar/scripts/set_walpaper.sh &
