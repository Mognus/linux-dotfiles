#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
mapfile -t packages < <(awk '!/^#/ && NF { print $1 }' "$repo_dir/packages.txt")

if ! command -v pacman >/dev/null 2>&1; then
    printf 'Error: this installer requires an Arch-based system.\n' >&2
    exit 1
fi

# Install Stow first so conflicts are detected before the full package transaction.
sudo pacman -S --needed stow
stow --simulate --dir="$repo_dir" --target="$HOME" .

sudo pacman -S --needed "${packages[@]}"
stow --dir="$repo_dir" --target="$HOME" .

# Materialize the saved palette before themed applications launch.
"$HOME/.config/hypr/scripts/theme-switcher.sh" --apply

# Cursor settings are best-effort because TTY installs may have no D-Bus session.
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface cursor-theme 'macOS' ||
        printf 'Warning: could not apply the cursor theme through gsettings.\n' >&2
    gsettings set org.gnome.desktop.interface cursor-size 40 ||
        printf 'Warning: could not apply the cursor size through gsettings.\n' >&2
fi

# Firefox userChrome.css — symlink into the active profile when one exists.
firefox_root="$HOME/.mozilla/firefox"
firefox_profile=""
if [[ -d "$firefox_root" ]]; then
    firefox_profile="$(find "$firefox_root" -maxdepth 1 -name '*.default-release' -type d -print -quit)"
fi

if [[ -n "$firefox_profile" ]]; then
    mkdir -p "$firefox_profile/chrome"
    ln -sfn "$repo_dir/firefox/userChrome.css" "$firefox_profile/chrome/userChrome.css"
    printf 'Firefox: symlinked userChrome.css -> %s/chrome/\n' "$firefox_profile"
else
    printf 'Firefox: no default-release profile found, skipping\n'
fi
