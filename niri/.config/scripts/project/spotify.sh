#!/usr/bin/env bash

spawn() {
    niri msg action spawn -- "$@"
}

spawn env \
    LD_PRELOAD=/usr/local/lib/spotify-adblock.so \
    spotify
