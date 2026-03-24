#!/bin/bash
# Links dotfiles into the correct locations.
# Run once on a new system after cloning.

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "Removing existing: $dst"
        rm -rf "$dst"
    fi

    ln -s "$src" "$dst"
    echo "Linked: $dst → $src"
}

# ~/.config/ — whole directories
for dir in hypr waybar dunst alacritty fontconfig; do
    link "$DOTFILES/$dir" "$HOME/.config/$dir"
done
link "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# ~/.claude/
link "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"

# ~/
link "$DOTFILES/home/zshrc"     "$HOME/.zshrc"
link "$DOTFILES/home/tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES/home/gitconfig" "$HOME/.gitconfig"

echo "Done."
