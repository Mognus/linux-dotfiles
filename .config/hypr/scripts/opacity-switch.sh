#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
    up|down) direction="$1" ;;
    *) printf 'Usage: %s <up|down>\n' "$0" >&2; exit 1 ;;
esac

state_dir="$HOME/.local/state/alacritty"
config="$state_dir/opacity.toml"
mkdir -p "$state_dir"

# Key repeat can start multiple processes before the previous write finishes.
exec 9> "$state_dir/opacity.lock"
flock 9

source_config="$config"
if [[ ! -f "$source_config" ]]; then
    source_config="$HOME/.config/alacritty/defaults.toml"
fi
current="$(awk '$1 == "opacity" && $2 == "=" { print $3; exit }' "$source_config")"
if [[ ! "$current" =~ ^(0(\.[0-9]+)?|1(\.0+)?)$ ]]; then
    printf 'Invalid opacity in %s: %s\n' "$source_config" "$current" >&2
    exit 1
fi

new="$(awk -v cur="$current" -v dir="$direction" '
BEGIN {
    val = cur + ((dir == "up") ? 0.05 : -0.05)
    if (val > 1.0) val = 1.0
    if (val < 0.1) val = 0.1
    printf "%.2f", val
}')"

# Atomic replacement keeps Alacritty from loading a partially written file.
temporary="$(mktemp "$state_dir/.opacity.XXXXXX")"
trap 'rm -f -- "$temporary"' EXIT
printf '[window]\nopacity = %s\n' "$new" > "$temporary"
mv -- "$temporary" "$config"
flock -u 9
notify-send -t 800 "Alacritty Opacity" "$new" 2>/dev/null || true
