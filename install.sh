#!/bin/bash
set -e

if ! pacman -Qi base-devel &>/dev/null; then
    sudo pacman -S --needed base-devel git
fi

parse_section() {
    local file="$1"
    local section="$2"

    if [ "$section" = "pacman" ]; then
        sed -n '/^\# \[AUR\]/q;p' "$file"
    else
        sed -n '/^\# \[AUR\]/,$ p' "$file"
    fi | grep -v '^#' | sed 's/#.*//' | awk '{print $1}' | grep -v '^$' | tr '\n' ' '
}

pacman_pkgs=$(parse_section "$HOME/dotfiles/packages.txt" "pacman")
aur_pkgs=$(parse_section "$HOME/dotfiles/packages.txt" "aur")

sudo pacman -S --needed $pacman_pkgs
yay -S --needed $aur_pkgs

stow --dir="$HOME/dotfiles" --target="$HOME" .
