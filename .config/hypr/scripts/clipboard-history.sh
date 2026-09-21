#!/usr/bin/env bash
set -euo pipefail

pick() {
    # cliphist prints "<id>\t<preview>"; show only the preview and keep the id.
    local selected
    selected="$(cliphist list | rofi -dmenu -i -p Clipboard -display-columns 2 || true)"
    [[ -n "$selected" ]] || return 0
    printf '%s\n' "$selected" | cliphist decode | wl-copy
}

wipe() {
    cliphist wipe
    notify-send -t 1200 Clipboard "History gelöscht" 2>/dev/null || true
}

case "${1:-}" in
    pick) pick ;;
    wipe) wipe ;;
    *) printf 'Usage: %s <pick|wipe>\n' "$0" >&2; exit 1 ;;
esac
