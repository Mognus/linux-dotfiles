# Default editor — used by git, frg, etc.
set -gx EDITOR nvim
set -gx VISUAL nvim

# PATH must be set for non-interactive shells too: editor tasks, git hooks and
# other subprocesses never reach the interactive branch below. -g keeps this
# reproducible instead of relying on the universal variable store, which is
# machine-local and not versioned.
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -g $HOME/.local/bin /usr/local/go/bin $PNPM_HOME

if not status is-interactive
    return
end

set -g fish_transient_prompt 1

# Keep command overrides unset so FZF can use its context-aware walker.
set -e FZF_CTRL_T_COMMAND
set -e FZF_ALT_C_COMMAND
command -q fzf; and fzf --fish | source

alias ll='ls -lah --group-directories-first --color=auto'
