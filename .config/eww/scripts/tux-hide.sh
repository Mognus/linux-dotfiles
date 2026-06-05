#!/bin/bash
eww close tux-angel 2>/dev/null

# poll cursor position until it leaves the bottom-right corner
while true; do
    read x y <<< $(hyprctl cursorpos | tr ',' ' ')
    # tux occupies roughly the last 126px on right, 136px from bottom (1080-136=944)
    if [ "$x" -lt 1794 ] || [ "$y" -lt 944 ]; then
        break
    fi
    sleep 0.1
done

eww open tux-angel 2>/dev/null
