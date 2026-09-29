#!/usr/bin/env bash

# Ambil daftar Wi-Fi
nmcli -t -f SSID,SIGNAL device wifi list | awk -F: '{if ($1!="") print $1 "|" $2}'
