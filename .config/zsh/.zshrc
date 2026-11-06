# Persistent history, shared between interactive shells.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

bindkey -e

source "$ZDOTDIR/modules/completion.zsh"

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if [[ -n $WAYLAND_DISPLAY && -S $XDG_RUNTIME_DIR/ssh-agent ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
fi

# Load internal .zsh files
source "$ZDOTDIR/modules/functions.zsh"
source "$ZDOTDIR/modules/keybinds.zsh"
source "$ZDOTDIR/modules/prompt.zsh"

# Load external Plugins
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/autosuggestions.zsh"
# Load last so highlighting sees all widgets, including FZF's bindings.
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/syntax-highlighting.zsh"
