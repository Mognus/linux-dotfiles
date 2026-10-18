#!/usr/bin/env bash
set -euo pipefail

state_dir="${THEME_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-theme}"
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
palette_dir="$(readlink -f "$script_dir/../../themes/palettes")"
writer="$script_dir/../../../tools/appearancectl/bin/appearancectl"
announce=true

requested="${1:-}"
if [[ "$requested" == "--apply" ]]; then
    announce=false
    requested="$(cat "$state_dir/current" 2>/dev/null || printf retro-dark)"
elif [[ -z "$requested" ]]; then
    # Picking happens in Quickshell's settings menu (Theme).
    printf 'Usage: %s <theme> | --apply\n' "$0" >&2
    exit 1
fi

theme="$(printf '%s' "$requested" | tr '[:upper:]' '[:lower:]')"
palette="$palette_dir/$theme.json"
[[ -f "$palette" ]] || { printf 'Unknown theme: %s\n' "$requested" >&2; exit 1; }
[[ -x "$writer" ]] || { printf 'Build appearancectl first: make -C %s/../../../tools/appearancectl\n' "$script_dir" >&2; exit 1; }

mkdir -p "$state_dir"
tmp_dir="$(mktemp -d "$state_dir/.generate.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

value() { jq -er ".$1" "$palette"; }

# Quickshell watches this file, while other apps import their generated format.
cp "$palette" "$tmp_dir/colors.json"

cat > "$tmp_dir/gtk.css" <<EOF
@define-color theme_bg_color $(value background);
@define-color theme_fg_color $(value foreground);
@define-color theme_base_color $(value surface);
@define-color theme_text_color $(value foreground);
@define-color theme_selected_bg_color $(value accent);
@define-color theme_selected_fg_color $(value background);
@define-color accent_bg_color $(value accent);
@define-color accent_color $(value accent);
@define-color accent_fg_color $(value background);
@define-color window_bg_color $(value background);
@define-color window_fg_color $(value foreground);
EOF

# The shared writer preserves terminal adjustments while replacing colors.
THEME_STATE_DIR="$state_dir" "$writer" theme "$palette" >/dev/null

# Atomic replacement prevents file watchers from reading half-written configs.
for file in colors.json gtk.css; do
    mv "$tmp_dir/$file" "$state_dir/$file"
done
printf '%s\n' "$theme" > "$state_dir/current"

if [[ "$(value mode)" == light ]]; then
    gtk_theme=Adwaita
    color_scheme=prefer-light
else
    gtk_theme=Adwaita-dark
    color_scheme=prefer-dark
fi

# dconf needs no schemas, unlike gsettings on NixOS. Home Manager must not set
# these keys, or every rebuild would reset the theme.
dconf write /org/gnome/desktop/interface/gtk-theme "'$gtk_theme'"
dconf write /org/gnome/desktop/interface/color-scheme "'$color_scheme'"

if $announce; then
    notify-send -t 1200 Theme "$(value name)" 2>/dev/null || true
fi
