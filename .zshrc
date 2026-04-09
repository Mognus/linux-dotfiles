# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# zoxide
eval "$(zoxide init zsh)"

# Aliases
alias ll='ls -al'
alias ss='grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%T).png'
alias ssf='grim ~/Pictures/Screenshots/$(date +%F_%T).png'
alias sse='grim -g "$(slurp)" - | swappy -f -'
alias ssc='grim -g "$(slurp)" - | wl-copy'
alias ta='tmux attach -t'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'

# Keybindings
bindkey "$terminfo[kcuu1]" history-substring-search-up    # Up
bindkey "$terminfo[kcud1]" history-substring-search-down  # Down
bindkey "^[[1;5C" forward-word     # Ctrl+→
bindkey "^[[1;5D" backward-word    # Ctrl+←
bindkey "^G" fzf-cd-widget         # Ctrl+G → cd jump

# PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin

# Git info
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{244} (%b)%f'

_full_prompt='
%F{236}┌─%f %F{green}%n@%m%f %F{246}%~%f${vcs_info_msg_0_} %F{white}%*%f
%F{236}└─%f%F{cyan}❯%f '

# Restore full prompt and update vcs_info before each prompt
precmd() {
    vcs_info
    PROMPT=$_full_prompt
    RPROMPT=''
}

# Transient prompt — replace full prompt with simple ❯ after Enter
_transient_prompt() {
    PROMPT='%F{cyan}❯%f '
    RPROMPT='%F{245}%*%f'
    zle reset-prompt
}
zle -N zle-line-finish _transient_prompt
