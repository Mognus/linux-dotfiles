# These helpers only work inside a graphical Wayland session.
if not status is-interactive; or not set -q WAYLAND_DISPLAY
    return
end

function sc
    grim -g (slurp) ~/Pictures/screenshots/(date +%F_%T).png
end

function scf
    grim ~/Pictures/screenshots/(date +%F_%T).png
end

function sce
    grim -g (slurp) - | swappy -f -
end

function scc
    grim -g (slurp) - | wl-copy
end
