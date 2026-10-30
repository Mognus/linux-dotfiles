# Persistent history, shared between interactive shells.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

bindkey -e

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

# Load after FZF so native completion owns Tab; keybindings.zsh remaps FZF.
source "$ZDOTDIR/plugins/completion.zsh"
source "$ZDOTDIR/plugins/gh-repos.zsh"

if [[ -n $WAYLAND_DISPLAY && -S $XDG_RUNTIME_DIR/ssh-agent ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
fi

source "$ZDOTDIR/keybindings.zsh"
source "$ZDOTDIR/prompt.zsh"
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/autosuggestions.zsh"
# Load last so highlighting sees all widgets, including FZF's bindings.
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/syntax-highlighting.zsh"
