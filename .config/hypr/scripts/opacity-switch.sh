#!/bin/bash
set -euo pipefail

config="$HOME/.config/alacritty/alacritty.toml"
step=0.05
min=0.1
max=1.0
direction="${1:?usage: opacity-switch.sh <up|down>}"

current="$(grep -oP '(?<=^opacity = )[0-9.]+' "$config")"

# alacritty hot-reloads its config, so just rewrite the value
new="$(awk -v cur="$current" -v step="$step" -v dir="$direction" -v min="$min" -v max="$max" '
BEGIN {
    val = (dir == "up") ? cur + step : cur - step
    if (val > max) val = max
    if (val < min) val = min
    printf "%.2f", val
}')"

sed -i "s/^opacity = .*/opacity = ${new}/" "$config"
notify-send -t 800 "Alacritty Opacity" "${new}"
