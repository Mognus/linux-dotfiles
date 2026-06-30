#!/bin/bash
set -euo pipefail

wallpaper_dirs=(
    "$HOME/Pictures/wallpapers"
    "$HOME/.config/wallpapers"
)

if ! pgrep -x awww-daemon > /dev/null; then
    awww-daemon &
    sleep 0.2
fi

selected="$(
    find "${wallpaper_dirs[@]}" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) \
        -printf '%f\t%p\n' 2> /dev/null |
    sort |
    rofi -dmenu -i -p "Wallpaper" -display-columns 1 |
    cut -f2-
)"

if [[ -n "${selected}" ]]; then
    awww img "${selected}" \
        --transition-type any \
        --transition-duration 1 \
        --transition-fps 60
fi
