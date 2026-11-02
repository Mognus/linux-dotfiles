# Load the selectable completion menu before initializing completion widgets.
zmodload zsh/complist
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

# Ignore case. Try prefixes first; match inside names only if no prefix matches.
# Example: uk prefers uk-notes.md; otherwise it can match cover-letter-ukj.pdf.
zstyle ':completion:*' matcher-list \
    'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' group-name ''

# Insert the common prefix and show the available completions.
setopt AUTO_LIST COMPLETE_IN_WORD ALWAYS_TO_END
unsetopt LIST_AMBIGUOUS
bindkey '^I' expand-or-complete
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
