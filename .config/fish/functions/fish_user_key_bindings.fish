function fish_user_key_bindings
    bind \cw backward-kill-path-component
    bind \cg 'commandline -f repaint; frg; commandline -f repaint'
    bind \cx 'commandline -f repaint; fkill; commandline -f repaint'
end
