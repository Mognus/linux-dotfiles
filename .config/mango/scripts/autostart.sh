#!/usr/bin/env bash

# Use the desktop headset if connected; keep the laptop's default otherwise.
microphone=alsa_input.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo
if pactl list short sources | cut -f2 | grep -Fxq "$microphone"; then
    pactl set-default-source "$microphone"
fi

bash "$HOME/.config/hypr/scripts/polkit-agent.sh" &
wl-paste --watch cliphist store &

# Generate the saved palette before starting Quickshell.
if bash "$HOME/.config/hypr/scripts/theme-switcher.sh" --apply; then
    # Workspace indicators and window switching still need the Mango port.
    qs -p "$HOME/.config/quickshell" &
else
    printf 'Mango autostart: could not apply the saved theme\n' >&2
fi

awww-daemon &

# Wait up to five seconds for the wallpaper daemon's socket to become ready.
for ((attempt = 0; attempt < 50; attempt++)); do
    if awww query >/dev/null 2>&1; then
        awww img "$HOME/.config/wallpapers/Tank-Girl-Wallpaper-Black.png"
        exit "$?"
    fi
    sleep 0.1
done

printf 'Mango autostart: wallpaper daemon did not become ready\n' >&2
exit 1
