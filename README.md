# Dotfiles

Personal Linux dotfiles managed with GNU Stow.

The repository contains my daily desktop and terminal configuration, including
Neovim, Fish, Tmux, Alacritty, Hyprland, Quickshell, Rofi, Dunst, the desktop
theme switcher, Git, CLI tooling and package lists for rebuilding a workstation.

A visual showcase of this setup, with screenshots and the matching configs, is
online at <https://freierfreier23.de/en/personal-setup>.

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
`packages.txt`, links the dotfiles into `$HOME`, applies the saved theme palette
and cursor defaults, and symlinks `firefox/userChrome.css` into the active
Firefox profile when one exists.

## Link Only

If packages are already installed, only create the symlinks:

```sh
stow --dir="$PWD" --target="$HOME" .
```

Local machine files and generated state are ignored through `.gitignore` and
`.stow-local-ignore`.

## Documentation

Every topic is documented next to its own config, in a `showcase/` folder that
also holds the screenshots used on the website:

- [Alacritty](.config/alacritty/showcase/README.md)
- [Fish](.config/fish/showcase/README.md)
- [Git](.config/git/showcase/README.md)
- [Hyprland](.config/hypr/showcase/README.md)
- [Neovim](.config/nvim/showcase/README.md)
- [Notifications](.config/dunst/showcase/README.md)
- [Quickshell](.config/quickshell/showcase/README.md)
- [Tmux](.config/tmux/showcase/README.md)
- [Tools and packages](.config/tools/showcase/README.md)

The GPG private key, `~/.password-store`, system services, and other mutable
data need a separate backup and restore process.
