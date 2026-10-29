# Persistent history, shared between interactive shells.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

bindkey -e

# Native completion, with grouped descriptions and a selectable menu.
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%B%d%b'
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

source "$ZDOTDIR/plugins/personal/gh-repos.zsh"

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if [[ -n $WAYLAND_DISPLAY && -S $XDG_RUNTIME_DIR/ssh-agent ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
fi

source "$ZDOTDIR/plugins/autosuggestions.zsh"
# Load last so highlighting sees all widgets, including FZF's bindings.
source "$ZDOTDIR/plugins/syntax-highlighting.zsh"
