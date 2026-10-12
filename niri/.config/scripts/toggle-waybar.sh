#!/bin/bash
if [ -z $(pidof waybar) ]; then
  waybar -c /home/iko/.config/dotfiles/niri/.config/waybar/config -s /home/iko/.config/dotfiles/niri/.config/waybar/style.css &
else
  pkill waybar
fi
