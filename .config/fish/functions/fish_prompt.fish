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

    set_color brblack
    printf '%s\n' (prompt_pwd)

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
        set_color 777777
        printf '%s' (date +%H:%M:%S)
        set_color normal
    end
end
