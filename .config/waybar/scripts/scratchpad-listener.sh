#!/bin/bash
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -u UNIX-CONNECT:"$socket" - | while read -r event; do
    if echo "$event" | grep -q 'activespecial.*firefox'; then
        pkill -RTMIN+8 waybar
    elif echo "$event" | grep -q 'activespecial.*discord'; then
        pkill -RTMIN+9 waybar
    elif echo "$event" | grep -q 'activespecial.*notes'; then
        pkill -RTMIN+10 waybar
    elif echo "$event" | grep -q 'activespecial.*music'; then
        pkill -RTMIN+11 waybar
    elif echo "$event" | grep -q 'activespecial.*cmus'; then
        pkill -RTMIN+11 waybar
    elif echo "$event" | grep -q 'activespecial.*term'; then
        pkill -RTMIN+13 waybar
    elif echo "$event" | grep -q '^activespecial>>,'; then
        pkill -RTMIN+8 waybar
        pkill -RTMIN+9 waybar
        pkill -RTMIN+10 waybar
        pkill -RTMIN+11 waybar
        pkill -RTMIN+12 waybar
        pkill -RTMIN+13 waybar
    fi
done
