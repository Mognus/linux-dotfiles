#!/bin/bash
visible=$(hyprctl monitors -j | jq '[.[] | select(.specialWorkspace.name == "special:discord")] | length')
exists=$(hyprctl workspaces -j | jq '[.[] | select(.name == "special:discord")] | length')

if [ "$visible" -gt 0 ]; then
    printf '{"text": "\uf025", "class": "visible", "tooltip": "Discord Scratchpad (offen)"}\n'
elif [ "$exists" -gt 0 ]; then
    printf '{"text": "\uf025", "class": "hidden", "tooltip": "Discord Scratchpad (versteckt)"}\n'
else
    printf '{"text": "\uf025", "class": "empty", "tooltip": "Discord Scratchpad (nicht gestartet)"}\n'
fi
