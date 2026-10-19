# Packages

Packages come from three NixOS modules:

- `nix/home/packages.nix` - general programs, grouped by purpose.
- `nix/home/magnus.nix` - tools a linked config depends on, next to that config.
- `nix/modules/common.nix` - system programs, fonts and services.

Apply changes with `sudo nixos-rebuild switch --flake ~/dotfiles/nix`.

## Shell

- `fish` - daily interactive shell
- `tmux` - persistent terminal sessions
- `fzf` - fuzzy search for history, files, and directories
- `fd` - fast, ignore-aware file search

## Editor and Terminal

- `neovim` - editor
- `alacritty` - terminal emulator

NixOS supplies IBM VGA for monospace text, Alacritty and Quickshell, and IBM Plex
Sans for GUI text. See `fonts.md`.

## Desktop

- `hyprland` - Wayland compositor
- `quickshell` - lightweight desktop widgets
- `awww`, `hypridle` - wallpaper and idle handling
- `xdg-desktop-portal-hyprland` - portal integration for Wayland apps
- `gvfs`, `tumbler`, `ffmpegthumbnailer` - file manager access and previews

## Wayland Helpers

- `grim` - screenshots
- `slurp` - region selection
- `wl-clipboard` - clipboard access
- `cliphist` - clipboard history behind the Quickshell overlay
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
- `podman` and `podman-compose` - rootless containers
- `ansible` - infrastructure automation
- `typst` - document typesetting

## System Tools

- `git` and `github-cli` - version control and GitHub workflow
- `pass` - GPG-backed password storage
- `curl`, `wget`, `openssh` - network and remote access
- `ripgrep` - fast text search, also used by Neovim's grep picker
- `bind` - DNS diagnostic commands
- `unzip` and `7zip` - archive extraction
