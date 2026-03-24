#!/bin/bash
# Shows Firefox scratchpad status in Waybar.
# "visible" = scratchpad is currently shown on screen
# "hidden"  = Firefox is running in scratchpad but toggled off
# "empty"   = scratchpad doesn't exist yet

echo "$(date): script called" >> /tmp/waybar-debug.log
visible=$(hyprctl monitors -j | jq '[.[] | select(.specialWorkspace.name == "special:firefox")] | length')
exists=$(hyprctl workspaces -j | jq '[.[] | select(.name == "special:firefox")] | length')

if [ "$visible" -gt 0 ]; then
    printf '{"text": "\uf269", "class": "visible", "tooltip": "Firefox Scratchpad (offen)"}\n'
elif [ "$exists" -gt 0 ]; then
    printf '{"text": "\uf269", "class": "hidden", "tooltip": "Firefox Scratchpad (versteckt)"}\n'
else
    printf '{"text": "\uf269", "class": "empty", "tooltip": "Firefox Scratchpad (nicht gestartet)"}\n'
fi
