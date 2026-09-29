#!/usr/bin/env bash

export NEWT_COLORS='
root=black,white
roottext=black,white

border=black,lightgray
window=black,lightgray
shadow=black,gray

title=black,lightgray

button=black,lightgray
actbutton=black,white
compactbutton=black,lightgray

checkbox=black,lightgray
actcheckbox=black,white

entry=black,white
disentry=gray,lightgray

label=black,lightgray

listbox=black,lightgray
actlistbox=black,white
sellistbox=black,lightgray
actsellistbox=black,white

textbox=black,lightgray
acttextbox=black,white

helpline=gray,lightgray
'

exec kitty \
    --class nmtui-floating \
    --title "Network Manager" \
    nmtui
