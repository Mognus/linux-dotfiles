if status is-interactive
    set -g fish_transient_prompt 1
    fish_add_path $HOME/.local/bin /usr/local/go/bin

    command -q fzf; and fzf --fish | source
    command -q zoxide; and zoxide init fish | source

    alias ll='ls -al'
    alias ta='tmux attach -t'
    alias tn='tmux new-session -s'
    alias tk='tmux kill-session -t'

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
