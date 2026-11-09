# Treat / as a word boundary for word movement and Ctrl+W.
WORDCHARS=${WORDCHARS//\/}

# Ctrl+Left / Ctrl+Right: move one word in Alacritty and tmux.
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Tab completes and cycles through the candidates; Shift+Tab reverses.
bindkey '^I' menu-complete
bindkey '^[[Z' reverse-menu-complete
