# Extend only `gh repo clone <repository>`; keep upstream completion elsewhere.
_personal_gh_repos() {
    local host=${GH_HOST:-github.com}
    local account
    local cache_directory="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/gh-repos"
    local cache_file temporary_file
    local repository_list refreshed_list
    local cache_max_age=300 # Five minutes, in seconds.
    local cache_age=$cache_max_age # A missing cache needs a refresh.
    local -A cache_metadata
    local -a repositories

    # Read the active configured account locally, without a network request.
    account=$(gh config get user --host "$host" 2>/dev/null) || return 1
    [[ -n $account ]] || return 1

    # Replace characters that do not belong in the cache filename with underscores.
    local safe_host=${host//[^a-zA-Z0-9.-]/_}
    local safe_account=${account//[^a-zA-Z0-9_-]/_}
    cache_file="$cache_directory/$safe_host-$safe_account"

    # Load Zsh's clock and file metadata helpers to check the cache age.
    zmodload zsh/datetime
    zmodload -F zsh/stat b:zstat
    if [[ -f $cache_file ]]; then
        repository_list=$(<"$cache_file")
        if zstat -H cache_metadata -- "$cache_file"; then
            cache_age=$(( EPOCHSECONDS - cache_metadata[mtime] ))
        fi
    fi

    # Refresh on demand after five minutes; keep old data when offline.
    if (( cache_age >= cache_max_age )); then
        if refreshed_list=$(
            GH_HOST="$host" GH_PROMPT_DISABLED=1 timeout 5s \
                gh repo list "$account" \
                    --limit 1000 \
                    --json nameWithOwner \
                    --jq '.[].nameWithOwner' </dev/null 2>/dev/null
        ); then
            repository_list=$refreshed_list

            # Private repository names belong in a private, local cache.
            # The subshell keeps umask local; renaming avoids half-written files.
            (
                umask 077
                mkdir -p "$cache_directory" || exit 1
                temporary_file=$(mktemp "$cache_file.XXXXXX") || exit 1
                if print -r -- "$repository_list" > "$temporary_file"; then
                    mv -f -- "$temporary_file" "$cache_file"
                else
                    rm -f -- "$temporary_file"
                fi
            )
        fi
    fi

    if [[ -z $repository_list ]]; then
        _message 'No cached GitHub repositories available; check gh auth status'
        return 1
    fi
    # (@f) splits the newline-separated output into one array entry per repository.
    repositories=("${(@f)repository_list}")
    _describe 'GitHub repository' repositories
}

_personal_gh() {
    # CURRENT is the word at the cursor: gh(1) repo(2) clone(3) repository(4).
    if [[ $words[2] == repo
        && $words[3] == clone
        && $CURRENT == 4
        && $words[4] != -* ]]; then
        _personal_gh_repos
    else
        _gh "$@"
    fi
}

if (( $+commands[gh] )); then
    source <(gh completion --shell zsh)
    compdef _personal_gh gh
fi
