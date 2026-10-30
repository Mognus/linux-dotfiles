# Use Zsh's word-matching widget with separate rules for each binding.
autoload -Uz backward-kill-word-match

# Ctrl+W: delete a word segment; punctuation such as . / - _ separates words.
zle -N backward-kill-segment backward-kill-word-match
zstyle ':zle:backward-kill-segment' word-style normal
zstyle ':zle:backward-kill-segment' word-chars ''
bindkey '^W' backward-kill-segment

# Alt+Backspace: delete the whole whitespace-delimited word/path.
zle -N backward-kill-space-word backward-kill-word-match
zstyle ':zle:backward-kill-space-word' word-style whitespace
bindkey '^[^?' backward-kill-space-word
bindkey '^[^H' backward-kill-space-word

# Ctrl+U: delete only left of the cursor, preserving text to its right.
bindkey '^U' backward-kill-line
