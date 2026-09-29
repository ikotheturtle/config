#!/usr/bin/env bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-media-player"

player="$1"

case "$player" in
    spotify|firefox.instance_1_61)
        ;;
    *)
        exit 1
        ;;
esac

# Simpan player yang dipilih
printf '%s\n' "$player" > "$STATE_FILE"

# Hentikan worker media-player.sh yang sedang mengikuti player lama
pkill -f '/home/iko/.config/waybar/modules/media-player.sh'

# Tutup popup Eww
eww close media-player-selector
