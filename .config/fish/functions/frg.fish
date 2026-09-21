function frg
    set -l rg_prefix 'rg --column --line-number --no-heading --color=always --smart-case'
    # Start with an empty list; otherwise fzf fills it with its file walker
    # before the first keystroke and the preview gets filenames without lines.
    set -l result (
        true | fzf --ansi --disabled \
            --delimiter ':' \
            --bind "change:reload:$rg_prefix {q} || true" \
            --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --prompt 'rg> '
    )

    test -n "$result"; or return

    set -l file (string split ':' -- $result)[1]
    set -l line (string split ':' -- $result)[2]

    if set -q EDITOR
        $EDITOR +$line $file
    else
        nvim +$line $file
    end
end
