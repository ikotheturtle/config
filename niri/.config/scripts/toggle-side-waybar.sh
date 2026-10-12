#!/usr/bin/env bash

CONFIG="/home/iko/.config/waybar/project.jsonc"
STYLE="/home/iko/.config/waybar/project-style.css"

# Cek apakah instance project Waybar sedang berjalan
if pgrep -f "waybar.*$CONFIG" > /dev/null; then
    # Stop project sidebar
    pkill -f "waybar.*$CONFIG"
else
    # Start project sidebar
    waybar \
        -c "$CONFIG" \
        -s "$STYLE" \
        >/tmp/waybar-projects.log 2>&1 &
fi
