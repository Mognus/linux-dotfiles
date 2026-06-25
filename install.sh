#!/bin/bash
set -e

packages=$(grep -v '^#' "$HOME/dotfiles/packages.txt" | sed 's/#.*//' | awk '{print $1}' | grep -v '^$' | tr '\n' ' ')

sudo pacman -S --needed $packages

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
