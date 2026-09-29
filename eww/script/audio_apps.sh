#!/usr/bin/env bash

# -----------------------------
# Environment supaya wpctl jalan di EWW daemon
# -----------------------------
export PATH=$PATH:/usr/bin:/usr/local/bin
export XDG_RUNTIME_DIR=/run/user/1000
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# -----------------------------
# Ambil daftar audio streams & apps
# -----------------------------
/usr/bin/wpctl status 2>/dev/null | awk '
/Streams:/ {flag=1; next}
/^[[:space:]]*$/ {if(flag) exit}
/Video/ {if(flag) exit}
/Settings/ {if(flag) exit}

flag {
    # Hilangkan titik dari index
    gsub(/\./,"",$1)
    id=$1
    $1=""
    name=$0
    sub(/^[ \t]+/,"",name)
    gsub(/"/,"",name)
    apps[++i]=sprintf("{\"id\":\"%s\",\"name\":\"%s\"}",id,name)
}

END {
    if(i==0) {
        print "[]"
    } else {
        printf "["
        for(j=1;j<=i;j++){
            printf "%s%s",(j>1?",":""),apps[j]
        }
        print "]"
    }
}
'
