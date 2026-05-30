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

# Firefox userChrome.css — symlink into the active profile
FIREFOX_PROFILE=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -name "*.default-release" -type d | head -1)
if [ -n "$FIREFOX_PROFILE" ]; then
    mkdir -p "$FIREFOX_PROFILE/chrome"
    ln -sf "$HOME/dotfiles/firefox/userChrome.css" "$FIREFOX_PROFILE/chrome/userChrome.css"
    echo "Firefox: symlinked userChrome.css -> $FIREFOX_PROFILE/chrome/"
else
    echo "Firefox: no default-release profile found, skipping"
fi
