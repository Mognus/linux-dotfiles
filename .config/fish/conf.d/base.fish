# Default editor — used by git, frg, etc.
set -gx EDITOR nvim
set -gx VISUAL nvim

if not status is-interactive
    return
end

set -g fish_transient_prompt 1
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $HOME/.local/bin /usr/local/go/bin $PNPM_HOME

# Keep command overrides unset so FZF can use its context-aware walker.
set -e FZF_CTRL_T_COMMAND
set -e FZF_ALT_C_COMMAND
command -q fzf; and fzf --fish | source

alias ll='ls -lah --group-directories-first --color=auto'
