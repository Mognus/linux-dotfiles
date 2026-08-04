# Default editor — used by git, frg, etc.
set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    set -g fish_transient_prompt 1
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    fish_add_path $HOME/.local/bin /usr/local/go/bin $PNPM_HOME

    # Keep command overrides unset so FZF can use its context-aware walker.
    set -e FZF_CTRL_T_COMMAND
    set -e FZF_ALT_C_COMMAND
    command -q fzf; and fzf --fish | source

    alias ll='ls -lah --group-directories-first --color=auto'

    function sc
        grim -g (slurp) ~/Pictures/screenshots/(date +%F_%T).png
    end

    function scf
        grim ~/Pictures/screenshots/(date +%F_%T).png
    end

    function sce
        grim -g (slurp) - | swappy -f -
    end

    function scc
        grim -g (slurp) - | wl-copy
    end
end
