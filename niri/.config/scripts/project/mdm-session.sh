#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="/storage/MDM_project/MDM_project"
BACKEND_DIR="$PROJECT_DIR/Backend"

TIMEOUT=100


# ============================================================
# Helpers
# ============================================================

spawn() {
    niri msg action spawn -- "$@"
}


get_windows() {
    niri msg --json windows
}


snapshot_windows() {
    mapfile -t WINDOW_IDS < <(
        get_windows | jq -r '.[].id'
    )
}


wait_for_new_window() {
    local APP_ID="$1"
    shift

    local OLD_IDS=("$@")

    for ((i = 0; i < TIMEOUT; i++)); do

        local WINDOW_ID

        WINDOW_ID="$(
            get_windows |
                jq -r --arg app "$APP_ID" '
                    .[]
                    | select(.app_id == $app)
                    | .id
                ' |
                while read -r ID; do

                    [[ -z "$ID" ]] && continue

                    local IS_OLD=false

                    for OLD_ID in "${OLD_IDS[@]}"; do
                        if [[ "$ID" == "$OLD_ID" ]]; then
                            IS_OLD=true
                            break
                        fi
                    done

                    if [[ "$IS_OLD" == false ]]; then
                        echo "$ID"
                        break
                    fi

                done
        )"

        if [[ -n "$WINDOW_ID" ]]; then
            echo "$WINDOW_ID"
            return 0
        fi

        sleep 0.1
    done

    echo "Timeout waiting for new window: $APP_ID" >&2
    return 1
}


move_to_workspace() {
    local WINDOW_ID="$1"
    local WORKSPACE="$2"

    echo "Moving $WINDOW_ID -> workspace $WORKSPACE"

    niri msg action move-window-to-workspace \
        --window-id "$WINDOW_ID" \
        --focus false \
        "$WORKSPACE"
}


# ============================================================
# Workspace 1
# Zen Browser
# ============================================================

echo
echo "======================================"
echo " Workspace 1"
echo " Zen Browser"
echo "======================================"

snapshot_windows

spawn zen-browser

ZEN_ID="$(
    wait_for_new_window \
        "zen" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$ZEN_ID" 1


# ============================================================
# Workspace 2
# Kitty - BACKEND_DIR
# ============================================================

echo
echo "======================================"
echo " Workspace 2"
echo " Kitty - Backend"
echo "======================================"

snapshot_windows

spawn kitty \
    --working-directory "$BACKEND_DIR"

BACKEND_KITTY_ID="$(
    wait_for_new_window \
        "kitty" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$BACKEND_KITTY_ID" 2


# ============================================================
# Workspace 2
# Codex
# ============================================================

echo
echo "======================================"
echo " Workspace 2"
echo " Codex"
echo "======================================"

snapshot_windows

spawn kitty \
    --working-directory "$BACKEND_DIR" \
    zsh -lic \
    'codex resume 019f9f7a-bc3f-7000-a533-09bc77809d47'

CODEX_ID="$(
    wait_for_new_window \
        "kitty" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$CODEX_ID" 2


# ============================================================
# Workspace 2
# Kitty - PROJECT_DIR
# ============================================================

echo
echo "======================================"
echo " Workspace 2"
echo " Kitty - Project"
echo "======================================"

snapshot_windows

spawn kitty \
    --working-directory "$PROJECT_DIR"

PROJECT_KITTY_ID="$(
    wait_for_new_window \
        "kitty" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$PROJECT_KITTY_ID" 2


# ============================================================
# Workspace 3
# Bruno
# ============================================================

echo
echo "======================================"
echo " Workspace 3"
echo " Bruno"
echo "======================================"

snapshot_windows

spawn bruno

BRUNO_ID="$(
    wait_for_new_window \
        "bruno" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$BRUNO_ID" 3


# ============================================================
# Workspace 3
# Obsidian
# ============================================================

echo
echo "======================================"
echo " Workspace 3"
echo " Obsidian"
echo "======================================"

snapshot_windows

spawn obsidian \
    'obsidian://open?vault=MDM_Document'

OBSIDIAN_ID="$(
    wait_for_new_window \
        "md.obsidian.Obsidian" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$OBSIDIAN_ID" 3


# ============================================================
# Workspace 3
# Spotify
# ============================================================

echo
echo "======================================"
echo " Workspace 3"
echo " Spotify"
echo "======================================"

snapshot_windows

spawn env \
    LD_PRELOAD=/usr/local/lib/spotify-adblock.so \
    spotify

SPOTIFY_ID="$(
    wait_for_new_window \
        "spotify" \
        "${WINDOW_IDS[@]}"
)"

move_to_workspace "$SPOTIFY_ID" 3


# ============================================================
# Done
# ============================================================

echo
echo "======================================"
echo " MDM SESSION STARTED"
echo "======================================"
echo
echo "Workspace 1 : Zen"
echo "Workspace 2 : Backend Kitty + Codex + Project Kitty"
echo "Workspace 3 : Bruno + Obsidian + Spotify"
echo
