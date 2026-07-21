#!/usr/bin/env bash
set -euo pipefail

state_dir="${THEME_STATE_DIR:-$HOME/.local/state/dotfiles-theme}"
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
palette_dir="$(readlink -f "$script_dir/../../themes/palettes")"
announce=true

pick_theme() {
    local selected
    selected="$({
        for file in "$palette_dir"/*.json; do
            printf '%s\t%s\n' "$(jq -r .name "$file")" "$(basename "$file" .json)"
        done
    } | sort | rofi -dmenu -i -p Theme -display-columns 1)"
    [[ -n "$selected" ]] || exit 0
    printf '%s\n' "$selected" | cut -f2
}

requested="${1:-}"
if [[ "$requested" == "--apply" ]]; then
    announce=false
    requested="$(cat "$state_dir/current" 2>/dev/null || printf black)"
elif [[ -z "$requested" ]]; then
    requested="$(pick_theme)"
fi

theme="$(printf '%s' "$requested" | tr '[:upper:]' '[:lower:]')"
palette="$palette_dir/$theme.json"
[[ -f "$palette" ]] || { printf 'Unknown theme: %s\n' "$requested" >&2; exit 1; }

mkdir -p "$state_dir"
tmp_dir="$(mktemp -d "$state_dir/.generate.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

value() { jq -er ".$1" "$palette"; }
value_or() { jq -er ".$1 // .$2" "$palette"; }
hex() { value "$1" | tr -d '#'; }

# Quickshell watches this file, while other apps import their generated format.
cp "$palette" "$tmp_dir/colors.json"

cat > "$tmp_dir/rofi.rasi" <<EOF
* {
    bg: $(value background)e8;
    bg-alt: $(value surface)f2;
    bg-hover: $(value hover)f2;
    fg: $(value foreground)ff;
    fg-soft: $(value foregroundSoft)ff;
    muted: $(value muted)ff;
    edge: $(value border)ff;
    edge-muted: $(value borderMuted)ff;
    accent: $(value accent)ff;
    danger: $(value danger)ff;
}
EOF

cat > "$tmp_dir/alacritty.toml" <<EOF
[colors.primary]
background = "$(value_or terminalBackground background)"
foreground = "$(value_or terminalForeground foregroundSoft)"

[colors.cursor]
cursor = "$(value accent)"
text = "$(value_or terminalBackground background)"

[colors.selection]
background = "$(value accent)"
text = "$(value_or terminalForeground foregroundSoft)"
EOF

cat > "$tmp_dir/dunstrc" <<EOF
[global]
    monitor = 0
    origin = top-right
    offset = 10x10
    width = 300
    height = 100
    gap_size = 6
    padding = 10
    horizontal_padding = 12
    frame_width = 1
    frame_color = "$(value borderMuted)"
    font = MesloLGS Nerd Font 11
    line_height = 2
    corner_radius = 6
    timeout = 5

[urgency_low]
    background = "$(value surface)"
    foreground = "$(value foregroundSoft)"
    frame_color = "$(value borderMuted)"

[urgency_normal]
    background = "$(value surface)"
    foreground = "$(value foregroundSoft)"
    frame_color = "$(value accent)"

[urgency_critical]
    background = "$(value surface)"
    foreground = "$(value danger)"
    frame_color = "$(value danger)"
    timeout = 0
EOF

cat > "$tmp_dir/hyprlock.conf" <<EOF
\$theme_background = rgb($(hex background))
\$theme_surface = rgb($(hex surface))
\$theme_foreground = rgb($(hex foreground))
\$theme_muted = rgb($(hex muted))
\$theme_border = rgb($(hex border))
\$theme_accent = rgb($(hex accent))
\$theme_danger = rgb($(hex danger))
\$theme_warning = rgb($(hex warning))
EOF

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

# Atomic replacement prevents file watchers from reading half-written configs.
for file in colors.json rofi.rasi alacritty.toml dunstrc hyprlock.conf gtk.css; do
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

if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "$color_scheme" 2>/dev/null || true
fi

if pgrep -x dunst >/dev/null && command -v dunstctl >/dev/null; then
    dunstctl reload "$state_dir/dunstrc" >/dev/null 2>&1 || true
fi

if $announce; then
    notify-send -t 1200 Theme "$(value name)" 2>/dev/null || true
fi
