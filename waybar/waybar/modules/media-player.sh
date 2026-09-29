#!/usr/bin/env bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-media-player"

get_selected_player() {
    if [[ ! -f "$STATE_FILE" ]]; then
        return 1
    fi

    local selected
    selected=$(<"$STATE_FILE")

    if playerctl -l 2>/dev/null | grep -Fxq "$selected"; then
        printf '%s\n' "$selected"
        return 0
    fi

    return 1
}

get_playing_player() {
    while IFS= read -r player; do
        [[ -z "$player" ]] && continue

        if [[ "$(playerctl --player="$player" status 2>/dev/null)" == "Playing" ]]; then
            printf '%s\n' "$player"
            return 0
        fi
    done < <(playerctl -l 2>/dev/null)

    return 1
}

get_player() {
    if selected=$(get_selected_player); then
        printf '%s\n' "$selected"
        return 0
    fi

    if playing=$(get_playing_player); then
        printf '%s\n' "$playing"
        return 0
    fi

    playerctl -l 2>/dev/null | head -n 1
}

escape_json() {
    local value="$1"

    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    value=${value//$'\r'/\\r}

    printf '%s' "$value"
}

print_placeholder() {
    printf '%s\n' \
        '{"text":"󰎆  No media","class":"no-media","alt":"no-media","tooltip":"No media player"}'
}

print_metadata() {
    local player="$1"

    [[ -z "$player" ]] && return 1

    local metadata

    metadata=$(
        playerctl \
            --player="$player" \
            metadata \
            --format='{{status}}|{{artist}}|{{title}}' \
            2>/dev/null
    )

    [[ -z "$metadata" ]] && return 1

    local status artist title

    IFS='|' read -r status artist title <<< "$metadata"

    local track_info=""

    if [[ "$player" == "spotify" ]]; then
        local track_id

        track_id=$(
            playerctl \
                --player="$player" \
                metadata mpris:trackid \
                2>/dev/null
        )

        if [[ "$track_id" == *":ad:"* ]]; then
            track_info="Advertisement"
        fi
    fi

    if [[ -z "$track_info" ]]; then
        if [[ -n "$artist" && -n "$title" ]]; then
            track_info="$artist - $title"
        elif [[ -n "$title" ]]; then
            track_info="$title"
        else
            return 1
        fi
    fi

    if [[ "$status" == "Playing" ]]; then
        track_info="  $track_info"
    else
        track_info="  $track_info"
    fi

    local escaped_text
    escaped_text=$(escape_json "$track_info")

    printf \
        '{"text":"%s","class":"custom-%s","alt":"%s","tooltip":"%s"}\n' \
        "$escaped_text" \
        "$player" \
        "$player" \
        "$escaped_text"
}

while true; do
    player=$(get_player)

    # Tidak ada Spotify / Firefox / MPRIS player
    if [[ -z "$player" ]]; then
        print_placeholder
        sleep 1
        continue
    fi

    # Tampilkan metadata sekarang
    if ! print_metadata "$player"; then
        print_placeholder
    fi

    # Ikuti perubahan metadata player
    playerctl \
        --player="$player" \
        --follow \
        metadata \
        --format='{{status}}|{{artist}}|{{title}}' \
        2>/dev/null |
    while IFS= read -r _; do
        print_metadata "$player" || print_placeholder
    done

    # Kalau player ditutup / hilang, kembali ke loop.
    # Loop akan mencari player baru.
    sleep 1
done
