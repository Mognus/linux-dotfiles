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

link zshrc          "$HOME/.zshrc"
link tmux.conf      "$HOME/.tmux.conf"
link wezterm.lua    "$HOME/.wezterm.lua"
link starship.toml  "$HOME/.config/starship.toml"
link gitconfig      "$HOME/.gitconfig"

echo "Done."
