#!/bin/bash

SSID="$1"

# Kalau SSID-nya kosong, keluar
[ -z "$SSID" ] && exit 1

# Connect pakai nmcli (akan minta password kalau belum tersimpan)
nmcli dev wifi connect "$SSID"
