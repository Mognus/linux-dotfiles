#!/usr/bin/env bash
set -euo pipefail

thumb_dir="$HOME/.cache/cliphist-thumbs"

# Based on cliphist's contrib/cliphist-rofi-img: image rows look like
# "<id>\t[[ binary data 32 KiB png 200x120 ]]" and get a rofi icon marker.
# Thumbnails are cached by entry id because cliphist ids never change.
with_thumbnails() {
    local line id kind thumb
    mkdir -p "$thumb_dir"

    while IFS= read -r line; do
        # Browsers copy an HTML companion entry that is never what you want.
        [[ "$line" == *$'\t<meta http-equiv='* ]] && continue

        if [[ "$line" =~ ^([0-9]+)$'\t'\[\[\ binary\ data\ .*\ (png|jpg|jpeg|bmp|webp)\  ]]; then
            id="${BASH_REMATCH[1]}"
            kind="${BASH_REMATCH[2]}"
            thumb="$thumb_dir/$id.$kind"
            if [[ ! -s "$thumb" ]]; then
                # cliphist decode takes the whole list row, not just the id.
                if ! printf '%s\n' "$line" | cliphist decode > "$thumb.tmp"; then
                    rm -f -- "$thumb.tmp"
                    printf '%s\n' "$line"
                    continue
                fi
                mv -- "$thumb.tmp" "$thumb"
            fi
            printf '%s\0icon\x1f%s\n' "$line" "$thumb"
        else
            printf '%s\n' "$line"
        fi
    done
}

pick() {
    local selected
    selected="$(
        cliphist list | with_thumbnails |
            rofi -dmenu -i -p Clipboard -display-columns 2 -show-icons \
                -theme-str 'element-icon { size: 96px; }' \
                -theme-str 'listview { lines: 6; }' || true
    )"
    [[ -n "$selected" ]] || return 0
    printf '%s\n' "$selected" | cliphist decode | wl-copy
}

wipe() {
    cliphist wipe
    rm -rf -- "$thumb_dir"
    notify-send -t 1200 Clipboard "History gelöscht" 2>/dev/null || true
}

case "${1:-}" in
    pick) pick ;;
    wipe) wipe ;;
    *) printf 'Usage: %s <pick|wipe>\n' "$0" >&2; exit 1 ;;
esac
