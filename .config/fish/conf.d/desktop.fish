# These helpers only work inside a graphical Wayland session.
if not status is-interactive; or not set -q WAYLAND_DISPLAY
    return
end

# Use the per-user SSH agent socket for this shell session.
# Arch's systemd unit names it ssh-agent.socket, NixOS names it ssh-agent.
for socket in "$XDG_RUNTIME_DIR/ssh-agent.socket" "$XDG_RUNTIME_DIR/ssh-agent"
    if test -S $socket
        set -gx SSH_AUTH_SOCK $socket
        break
    end
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
