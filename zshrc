# tmux autostart — must run before everything else
if [ -z "$TMUX" ]; then
    # -d creates session in background, but throws error if session already exists
    # 2>/dev/null suppresses that error — session simply stays as is
    tmux new-session -d -s claude 2>/dev/null
    tmux new-session -d -s dev 2>/dev/null
    # -A: attach to main if it already exists instead of creating a new one
    exec tmux new-session -A -s main
fi

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
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Aliases
alias ll='ls -al'

# Keybindings
bindkey "$terminfo[kcuu1]" history-substring-search-up    # Up
bindkey "$terminfo[kcud1]" history-substring-search-down  # Down
bindkey "^[[1;5C" forward-word     # Ctrl+→
bindkey "^[[1;5D" backward-word    # Ctrl+←

# PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin

# Git info
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{244} (%b)%f'

_full_prompt='
%F{236}┌─%f %F{246}%~%f${vcs_info_msg_0_} %F{white}%*%f
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
    RPROMPT='%F{238}%*%f'
    zle reset-prompt
}
zle -N zle-line-finish _transient_prompt
