# Default editor — used by git, frg, etc.
set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    set -g fish_transient_prompt 1
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    fish_add_path $HOME/.local/bin /usr/local/go/bin $PNPM_HOME

    command -q fzf; and fzf --fish | source
    command -q zoxide; and zoxide init fish | source

    alias ll='ls -al'

    function sc
        grim -g (slurp) ~/Pictures/Screenshots/(date +%F_%T).png
    end

    function scf
        grim ~/Pictures/Screenshots/(date +%F_%T).png
    end

    function sce
        grim -g (slurp) - | swappy -f -
    end

    function scc
        grim -g (slurp) - | wl-copy
    end
end
