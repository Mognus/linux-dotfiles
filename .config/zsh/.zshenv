export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export EDITOR=nvim
export VISUAL=nvim
export PNPM_HOME="$HOME/.local/share/pnpm"
typeset -U path
path=("$HOME/.local/bin" /usr/local/go/bin "$PNPM_HOME" $path)
