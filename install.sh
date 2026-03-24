#!/bin/bash
# Run once after cloning to ~/dotfiles
stow --dir="$HOME/dotfiles" --target="$HOME" .
