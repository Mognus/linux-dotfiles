# Treat / as a word boundary for word movement and Ctrl+W.
WORDCHARS=${WORDCHARS//\/}

# Ctrl+Left / Ctrl+Right: move one word in Alacritty and tmux.
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Native completion menu.
bindkey '^I' complete-word
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
