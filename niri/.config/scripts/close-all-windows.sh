#!/usr/bin/env bash

set -euo pipefail

niri msg --json windows |
    jq -r '.[].id' |
    while read -r WINDOW_ID; do
        niri msg action close-window --id "$WINDOW_ID"
    done
