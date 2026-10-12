#!/bin/bash

INPUT_CONFIG="$HOME/.config/dotfiles/niri/.config/niri/input.kdl"

if grep -A5 'touchpad {' "$INPUT_CONFIG" | grep -qE '^[[:space:]]*off[[:space:]]*$'; then
    # Enable touchpad
    awk '
    /touchpad[[:space:]]*\{/ {
        print "    touchpad {"
        print "        tap"
        print "        natural-scroll"
        print "        dwt"
        skip=1
        next
    }

    skip && /^[[:space:]]*}/ {
        print "    }"
        skip=0
        next
    }

    !skip {
        print
    }
    ' "$INPUT_CONFIG" > "$INPUT_CONFIG.tmp" &&
    mv "$INPUT_CONFIG.tmp" "$INPUT_CONFIG"

    notify-send "Touchpad Enabled"

else
    # Disable touchpad
    awk '
    /touchpad[[:space:]]*\{/ {
        print "    touchpad {"
        print "        off"
        skip=1
        next
    }

    skip && /^[[:space:]]*}/ {
        print "    }"
        skip=0
        next
    }

    !skip {
        print
    }
    ' "$INPUT_CONFIG" > "$INPUT_CONFIG.tmp" &&
    mv "$INPUT_CONFIG.tmp" "$INPUT_CONFIG"

    notify-send "Touchpad Disabled"
fi

# Reload Niri configuration
niri msg action reload-config
