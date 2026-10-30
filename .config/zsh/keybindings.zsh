# Use Zsh's word-matching widget with separate rules for each binding.
autoload -Uz backward-kill-word-match

# Ctrl+W: delete a word segment; punctuation such as . / - _ separates words.
zle -N backward-kill-segment backward-kill-word-match
zstyle ':zle:backward-kill-segment' word-style normal
zstyle ':zle:backward-kill-segment' word-chars ''
bindkey '^W' backward-kill-segment

# Ctrl+U: delete only left of the cursor, preserving text to its right.
bindkey '^U' backward-kill-line

# Restore the standard Emacs bindings replaced by FZF's integration.
bindkey '^R' history-incremental-search-backward
bindkey '^T' transpose-chars
bindkey '^[c' capitalize-word

# FZF actions use Ctrl+X, then f, then an action; existing Ctrl+X bindings remain.
if (( $+functions[fzf-file-widget] )); then
    bindkey '^Xff' fzf-file-widget
    bindkey '^Xfd' fzf-cd-widget
    bindkey '^Xfh' fzf-history-widget
fi
