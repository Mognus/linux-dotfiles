#!/bin/bash
# Links all dotfiles from this repo into the correct locations.
# Run once on a new system after cloning.

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "Removing existing: $dst"
        rm "$dst"
    fi

    ln -s "$src" "$dst"
    echo "Linked: $dst → $src"
}

links=(
    "zshrc                                                $HOME/.zshrc"
    "tmux.conf                                            $HOME/.tmux.conf"
    "gitconfig                                            $HOME/.gitconfig"
    "claude/settings.json                                 $HOME/.claude/settings.json"
    "claude/CLAUDE.md                                     $HOME/.claude/CLAUDE.md"
    ".config/hypr/hyprland.conf                          $HOME/.config/hypr/hyprland.conf"
    ".config/hypr/hyprlock.conf                          $HOME/.config/hypr/hyprlock.conf"
    ".config/hypr/hyprpaper.conf                         $HOME/.config/hypr/hyprpaper.conf"
    ".config/waybar/config                               $HOME/.config/waybar/config"
    ".config/waybar/style.css                            $HOME/.config/waybar/style.css"
    ".config/waybar/scripts/firefox-scratchpad.sh        $HOME/.config/waybar/scripts/firefox-scratchpad.sh"
    ".config/waybar/scripts/discord-scratchpad.sh        $HOME/.config/waybar/scripts/discord-scratchpad.sh"
    ".config/dunst/dunstrc                               $HOME/.config/dunst/dunstrc"
    ".config/alacritty/alacritty.toml                    $HOME/.config/alacritty/alacritty.toml"
    ".config/fontconfig/fonts.conf                       $HOME/.config/fontconfig/fonts.conf"
    ".config/starship.toml                               $HOME/.config/starship.toml"
)

for entry in "${links[@]}"; do
    link $entry
done

echo "Done."
