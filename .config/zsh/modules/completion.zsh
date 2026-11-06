# Native completion: Tab opens the menu, Tab / Shift+Tab cycle candidates.
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zmodload zsh/complist
zstyle ':completion:*' menu select
