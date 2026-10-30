# Persistent history, shared between interactive shells.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

bindkey -e

# Zim's standalone completion preset owns compinit and matching rules.
zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"
# Keep ordinary shell globs case-sensitive; only completion uses smart case.
zstyle ':zim:glob' case-sensitivity sensitive
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/completion/init.zsh"

source "$ZDOTDIR/plugins/personal/gh-repos.zsh"

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if [[ -n $WAYLAND_DISPLAY && -S $XDG_RUNTIME_DIR/ssh-agent ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
fi

source "$ZDOTDIR/keybindings.zsh"
source "$ZDOTDIR/prompt.zsh"
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/autosuggestions.zsh"
# Load last so highlighting sees all widgets, including FZF's bindings.
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/syntax-highlighting.zsh"
