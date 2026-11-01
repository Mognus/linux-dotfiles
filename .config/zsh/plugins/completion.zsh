# Load the selectable completion menu before initializing completion widgets.
zmodload zsh/complist
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

# One matching rule: ignore case and allow text before/after the typed fragment.
# Example: uk matches cover-letter-ukj-jena.pdf, but not cover-letter-other.pdf.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
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
