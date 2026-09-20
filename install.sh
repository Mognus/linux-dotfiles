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
# Keep agent directories separate so Stow links their files individually.
mkdir -p "$HOME/.codex" "$HOME/.claude"
stow --simulate --dir="$repo_dir" --target="$HOME" .

sudo pacman -S --needed "${packages[@]}"
stow --dir="$repo_dir" --target="$HOME" .

# Both agents share one instruction file, excluded from Stow.
ln -sfn "$repo_dir/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sfn "$repo_dir/AGENTS.md" "$HOME/.claude/CLAUDE.md"

# Materialize the saved palette before themed applications launch.
"$HOME/.config/hypr/scripts/theme-switcher.sh" --apply

# Cursor settings are best-effort because TTY installs may have no D-Bus session.
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface cursor-theme 'macOS' ||
        printf 'Warning: could not apply the cursor theme through gsettings.\n' >&2
    gsettings set org.gnome.desktop.interface cursor-size 40 ||
        printf 'Warning: could not apply the cursor size through gsettings.\n' >&2
fi
