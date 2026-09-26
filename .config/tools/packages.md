# Packages

The package list lives in `packages.txt` at the repository root.

## Shell

- `fish` - daily interactive shell
- `tmux` - persistent terminal sessions
- `fzf` - fuzzy search for history, files, and directories
- `fd` - fast, ignore-aware file search

## Editor and Terminal

- `neovim` - editor
- `alacritty` - terminal emulator
- `ttf-meslo-nerd` - primary Nerd Font
- `ttf-jetbrains-mono-nerd` - secondary Nerd Font

## Desktop

- `hyprland` - Wayland compositor
- `quickshell` - lightweight desktop widgets
- `rofi` - app launcher and dmenu replacement
- `dunst` - notifications
- `hyprlock`, `awww`, `hypridle` - lock screen, wallpaper, and idle handling
- `xdg-desktop-portal-hyprland` - portal integration for Wayland apps
- `gvfs`, `tumbler`, `ffmpegthumbnailer` - file manager access and previews

## Wayland Helpers

- `grim` - screenshots
- `slurp` - region selection
- `wl-clipboard` - clipboard access
- `cliphist` - clipboard history for the Hyprland picker
- `swappy` - screenshot editor
- `socat` - IPC helper
- `jq` - JSON processing

## Audio and Bluetooth

- `pipewire`, `wireplumber`, `pipewire-alsa`, `pipewire-pulse` - audio stack
- `alsa-utils` and `pavucontrol` - audio controls
- `bluez` and `bluez-utils` - Bluetooth stack and CLI tools

## Apps

- `firefox` - browser
- `papers` - GTK document viewer for PDF and other document formats
- `loupe` - GTK image viewer
- `discord` - chat
- `obsidian` - notes
- `thunderbird` - mail
- `torbrowser-launcher` - Tor Browser
- `libreoffice-fresh` - office documents

## Development

- `rustup` and `rust-analyzer` - Rust toolchain and LSP server
- `go` - Go
- `nodejs` and `npm` - Node.js tooling
- `docker` and `docker-compose` - containers
- `podman` and `podman-compose` - rootless containers
- `ansible` - infrastructure automation
- `typst` - document typesetting

## System Tools

- `git` and `github-cli` - version control and GitHub workflow
- `pass` - GPG-backed password storage
- `curl`, `wget`, `openssh` - network and remote access
- `ripgrep`, `bat`, `glow`, `btop`, `fastfetch` - CLI quality-of-life tools
- `stow` - dotfiles symlink management
- `base-devel` - build tools used with Arch and the AUR
- `bind` - DNS diagnostic commands
- `reflector` - pacman mirror updates
- `ufw` - firewall
- `unzip` and `7zip` - archive extraction

`paru` and `paru-debug` are installed locally but are not in `packages.txt`: they
are AUR packages, so the pacman-only installer cannot install them directly.
