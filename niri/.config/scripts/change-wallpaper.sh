#!/bin/bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
NIRI_CONFIG="/home/iko/.config/dotfiles/niri/.config/niri/config.kdl"
NIRI_WALLPAPER_DIR="/home/iko/.config/dotfiles/niri/.config/wallpapers"

# ============================================================
# Arguments
# ============================================================

image="${1:-}"
mode="${2:-}"

if [[ -z "$image" ]]; then
    echo "[ERROR] Wallpaper path is required"
    echo
    echo "Usage:"
    echo "  $0 <wallpaper> <mode>"
    echo
    echo "Example:"
    echo "  $0 ~/Pictures/wallpapers/forest.jpg fill"
    exit 1
fi

if [[ -z "$mode" ]]; then
    mode="fill"
fi

# ============================================================
# Validate wallpaper
# ============================================================

if [[ ! -f "$image" ]]; then
    echo "[ERROR] Wallpaper not found:"
    echo "        $image"
    exit 1
fi

case "$mode" in
    stretch|fill|fit|center|tile)
        ;;
    *)
        echo "[ERROR] Invalid wallpaper mode: $mode"
        echo "[INFO] Valid modes: stretch, fill, fit, center, tile"
        exit 1
        ;;
esac

# ============================================================
# Dependencies
# ============================================================

_is_installed() {
    command -v "$1" >/dev/null 2>&1
}

deps=(magick swaybg awww)
missing=()

for dep in "${deps[@]}"; do
    if ! _is_installed "$dep"; then
        missing+=("$dep")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "[ERROR] Missing dependencies: ${missing[*]}"
    exit 1
fi

# ============================================================
# Directories
# ============================================================

mkdir -p "$WALLPAPER_DIR"
mkdir -p "$NIRI_WALLPAPER_DIR"

# ============================================================
# Copy wallpaper
# ============================================================

extension="${image##*.}"

workspace_wallpaper="$NIRI_WALLPAPER_DIR/workspace.${extension}"

echo "[INFO] New wallpaper:"
echo "       $image"

echo "[INFO] Copying wallpaper..."
cp -f "$image" "$workspace_wallpaper"

# ============================================================
# Calculate canvas color
# ============================================================

canvas_color="$(
    magick "$workspace_wallpaper" \
        -crop x1+0+0 \
        -resize 1x1 \
        txt:- |
        grep -o '#[0-9A-Fa-f]\{6\}' |
        head -n 1
)"

if [[ -z "$canvas_color" ]]; then
    canvas_color="#000000"
fi

echo "[INFO] Canvas color: $canvas_color"

# ============================================================
# Configure swaybg
# ============================================================

workspace_cmd="swaybg -i \"$workspace_wallpaper\" -m \"$mode\" -c \"$canvas_color\""

echo "[INFO] Updating Niri swaybg configuration..."

sed -i \
    "s|^spawn-sh-at-startup \"swaybg.*|spawn-sh-at-startup \"$workspace_cmd\"|" \
    "$NIRI_CONFIG"

# Stop current swaybg
pkill swaybg 2>/dev/null || true

# Start new swaybg
nohup sh -c "$workspace_cmd" >/dev/null 2>&1 &

# ============================================================
# Create overview backdrop
# ============================================================

backdrop="$NIRI_WALLPAPER_DIR/backdrop.${extension}"

echo "[INFO] Creating new overview backdrop..."

magick "$workspace_wallpaper" \
    -scale 10% \
    -blur 0x2.5 \
    -resize 1000% \
    "$backdrop"

# ============================================================
# Configure awww
# ============================================================

backdrop_cmd="awww-daemon & awww img \"$backdrop\""

echo "[INFO] Updating Niri awww configuration..."

sed -i \
    "s|^spawn-sh-at-startup \"awww.*img.*|spawn-sh-at-startup \"$backdrop_cmd\"|" \
    "$NIRI_CONFIG"

# Apply backdrop immediately
awww img "$backdrop"

echo
echo "[INFO] Wallpaper changed successfully."
echo "[INFO] Mode: $mode"
echo "[INFO] Wallpaper: $workspace_wallpaper"
echo "[INFO] Backdrop: $backdrop"
