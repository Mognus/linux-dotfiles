#!/bin/bash
# Links all dotfiles from this repo into the correct locations.
# Run once on a new system after cloning.

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dst="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dst")"

    # Remove existing file or symlink
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "Removing existing: $dst"
        rm "$dst"
    fi

    ln -s "$src" "$dst"
    echo "Linked: $dst → $src"
}

# --- Home ---
link zshrc      "$HOME/.zshrc"
link tmux.conf  "$HOME/.tmux.conf"
link gitconfig  "$HOME/.gitconfig"

# --- .config ---
link .config/hypr/hyprland.conf         "$HOME/.config/hypr/hyprland.conf"
link .config/hypr/hyprlock.conf         "$HOME/.config/hypr/hyprlock.conf"
link .config/hypr/hyprpaper.conf        "$HOME/.config/hypr/hyprpaper.conf"
link .config/waybar/config              "$HOME/.config/waybar/config"
link .config/waybar/style.css           "$HOME/.config/waybar/style.css"
link .config/dunst/dunstrc              "$HOME/.config/dunst/dunstrc"
link .config/alacritty/alacritty.toml  "$HOME/.config/alacritty/alacritty.toml"
link .config/starship.toml             "$HOME/.config/starship.toml"

echo "Done."
