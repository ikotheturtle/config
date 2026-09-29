#!/usr/bin/env bash

# Jalankan daemon jika belum aktif
if ! eww ping &>/dev/null; then
  eww daemon &
  sleep 0.5
fi

# Reload konfigurasi
# eww reload

# Cek apakah window sedang AKTIF
if eww active-windows | grep -q "wallpaper_popup"; then
  eww close wallpaper_popup

else
  eww open wallpaper_popup

fi
