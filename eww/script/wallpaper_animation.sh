#!/bin/bash

pkill -x mpvpaper
pkill -x swaybg

setsid mpvpaper -o "--loop-file=inf --no-audio --hwdec=vaapi --vd-lavc-threads=2 --profile=low-latency" eDP-1 "$HOME/Pictures/gif_wallpaper/Untitled_design.mp4" &
