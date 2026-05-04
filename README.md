# Dotfiles

Personal Linux dotfiles managed with GNU Stow.

The repository contains my daily desktop and terminal configuration, including
Neovim, Fish, Tmux, Hyprland, Waybar, Git, CLI tooling and package lists for
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

The installer installs packages from `packages.txt` and then links the dotfiles
into `$HOME` with Stow.

## Link Only

If packages are already installed, only create the symlinks:

```sh
stow --dir="$HOME/dotfiles" --target="$HOME" .
```

Local machine files and generated state are ignored through `.gitignore` and
`.stow-local-ignore`.
