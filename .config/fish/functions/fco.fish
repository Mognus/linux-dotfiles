function fco
    set -l branch (
        git branch --all --color=always |
            string match --invert --regex 'HEAD' |
            fzf --ansi |
            string replace --regex '^[*[:space:]]+' '' |
            string replace --regex '^remotes/[^/]+/' ''
    )

    test -n "$branch"; or return
    git checkout $branch
end
