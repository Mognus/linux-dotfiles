#!/bin/bash
eww close tux-devil 2>/dev/null

# poll cursor position until it leaves the bottom-left corner
while true; do
    read x y <<< $(hyprctl cursorpos | tr ',' ' ')
    # tux occupies roughly the first 139px on left, 136px from bottom (1080-136=944)
    if [ "$x" -gt 139 ] || [ "$y" -lt 944 ]; then
        break
    fi
    sleep 0.1
done

eww open tux-devil 2>/dev/null
