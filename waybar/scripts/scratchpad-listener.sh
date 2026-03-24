#!/bin/bash
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -u UNIX-CONNECT:"$socket" - | while read -r event; do
    if echo "$event" | grep -q 'activespecial.*firefox'; then
        pkill -RTMIN+8 waybar
    elif echo "$event" | grep -q 'activespecial.*discord'; then
        pkill -RTMIN+9 waybar
    elif echo "$event" | grep -q '^activespecial>>,'; then
        pkill -RTMIN+8 waybar
        pkill -RTMIN+9 waybar
    fi
done
