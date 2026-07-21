# Dotfiles

Personal Linux dotfiles managed with GNU Stow.

The repository contains my daily desktop and terminal configuration, including
Neovim, Fish, Tmux, Hyprland, Quickshell, Git, CLI tooling and package lists for
rebuilding a workstation.

## Install

Clone the repository into your home directory:

```sh
git clone https://github.com/Mognus/linux-dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the installer on an Arch based system:

```sh
./install.sh
```

The installer checks for Stow conflicts, installs the packages from
`packages.txt`, links the dotfiles into `$HOME`, and applies desktop defaults.

## Link Only

If packages are already installed, only create the symlinks:

```sh
stow --dir="$PWD" --target="$HOME" .
```

Local machine files and generated state are ignored through `.gitignore` and
`.stow-local-ignore`.

## Documentation

- [Alacritty](docs/alacritty.md)
- [Fish](docs/shell.md)
- [Git](docs/git.md)
- [Hyprland](docs/hyprland.md)
- [Neovim](docs/nvim.md)
- [Notifications](docs/notifications.md)
- [Quickshell](docs/quickshell.md)
- [Tmux](docs/tmux.md)
- [Tools and packages](docs/tools.md)

The GPG private key, `~/.password-store`, system services, and other mutable
data need a separate backup and restore process.
