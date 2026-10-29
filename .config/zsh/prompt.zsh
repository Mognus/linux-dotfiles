# Fish-style prompt: abbreviated green path, then a cyan/red dollar sign.
unsetopt PROMPT_SUBST

_personal_prompt_precmd() {
    local last_status=$?
    local display_path=$PWD
    local -a path_parts
    local index

    if [[ $PWD == $HOME || $PWD == $HOME/* ]]; then
        display_path="~${PWD#$HOME}"
    fi

    # Like Fish's prompt_pwd: ~/projects/example becomes ~/p/example.
    path_parts=("${(@s:/:)display_path}")
    for (( index = 1; index < ${#path_parts}; index++ )); do
        if [[ -n $path_parts[index] && $path_parts[index] != '~' ]]; then
            if [[ $path_parts[index] == .* ]]; then
                path_parts[index]=${path_parts[index][1,2]}
            else
                path_parts[index]=${path_parts[index][1]}
            fi
        fi
    done
    display_path="${(j:/:)path_parts}"

    if (( last_status == 0 )); then
        _personal_prompt_symbol='%F{cyan}$ %f'
    else
        _personal_prompt_symbol='%F{red}$ %f'
    fi

    # Double literal percent signs so directory names cannot add prompt escapes.
    PROMPT=$'\n%F{10}'"${display_path//\%/%%}"$'%f\n'"$_personal_prompt_symbol"
    RPROMPT=''
}

_personal_prompt_line_finish() {
    [[ -n $BUFFER ]] || return 0

    # Redraw the accepted command with only $ and the submission time.
    # Local values leave the next live prompt unchanged.
    local PROMPT=$'\n'"$_personal_prompt_symbol"
    local RPROMPT='%F{#777777}%D{%H:%M:%S}%f'
    zle .reset-prompt
}

autoload -Uz add-zsh-hook add-zle-hook-widget
add-zsh-hook precmd _personal_prompt_precmd
add-zle-hook-widget line-finish _personal_prompt_line_finish
