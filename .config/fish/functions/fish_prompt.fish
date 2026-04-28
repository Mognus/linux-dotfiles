function fish_prompt
    set -l last_status $status

    if test "$argv[1]" = --final-rendering
        if test $last_status -eq 0
            set_color cyan
        else
            set_color red
        end

        printf '❯ '
        set_color normal
        return
    end

    set -l git_branch (command git branch --show-current 2>/dev/null)

    set_color brblack
    printf '┌─'
    set_color normal
    printf ' '
    set_color green
    printf '%s@%s' $USER $hostname
    set_color normal
    printf ' '
    set_color brblack
    printf '%s' (prompt_pwd)

    if test -n "$git_branch"
        printf ' (%s)' $git_branch
    end

    set_color normal
    printf ' '
    set_color white
    printf '%s\n' (date +%H:%M:%S)

    set_color brblack
    printf '└─'
    set_color normal

    if test $last_status -eq 0
        set_color cyan
    else
        set_color red
    end

    printf '❯ '
    set_color normal
end

function fish_right_prompt
    if test "$argv[1]" = --final-rendering
        set_color brblack
        printf '%s' (date +%H:%M:%S)
        set_color normal
    end
end
