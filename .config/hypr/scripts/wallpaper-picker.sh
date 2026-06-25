#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
fallback_dir="$HOME/.config/wallpapers"

if [ ! -d "$wallpaper_dir" ] && [ -d "$fallback_dir" ]; then
    wallpaper_dir="$fallback_dir"
fi

if [ ! -d "$wallpaper_dir" ]; then
    command -v notify-send >/dev/null && notify-send "Wallpaper" "Directory not found: $wallpaper_dir"
    exit 1
fi

choice=$(
    find "$wallpaper_dir" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -printf '%f\n' | sort | rofi -dmenu -i -p "Wallpaper"
)

[ -n "$choice" ] || exit 0

wallpaper="$wallpaper_dir/$choice"

hyprctl hyprpaper unload all >/dev/null 2>&1 || true
hyprctl hyprpaper preload "$wallpaper"
hyprctl hyprpaper wallpaper ",$wallpaper"
command -v notify-send >/dev/null && notify-send "Wallpaper" "$choice"
