# Word characters listed explicitly: all specials except _ - / so those three are
# word boundaries for word movement and Ctrl+W.
WORDCHARS='*?.[]~=&;!#$%^(){}<>'

# Ctrl+Left / Ctrl+Right: move one word in Alacritty and tmux.
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Tab completes and cycles through the candidates; Shift+Tab reverses.
bindkey '^I' menu-complete
bindkey '^[[Z' reverse-menu-complete
