#!/usr/bin/env bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-media-player"

player="$1"

case "$player" in
    spotify|firefox.instance_1_61)
        printf '%s\n' "$player" > "$STATE_FILE"
        ;;
    *)
        exit 1
        ;;
esac

eww close media-player-selector
