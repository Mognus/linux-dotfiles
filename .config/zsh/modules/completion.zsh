# Native completion: Tab opens the menu, Tab / Shift+Tab cycle candidates.
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zmodload zsh/complist
zstyle ':completion:*' menu select
# Prefix matches win; then case-insensitive, then substring anywhere.
# So `papers gen/cover-letter/okm<Tab>` finds cover-letter-okm-....pdf.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'
