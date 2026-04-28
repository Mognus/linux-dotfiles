function fkill
    set -l pids (
        ps -u (whoami) -o pid=,comm=,args= |
            fzf --multi \
                --header 'Select process to kill' \
                --preview 'ps -p {1} -o pid,ppid,user,stat,%cpu,%mem,etime,command' \
                --preview-window 'up,4,border-bottom' |
            awk '{print $1}'
    )

    test (count $pids) -gt 0; or return
    kill $pids
end
