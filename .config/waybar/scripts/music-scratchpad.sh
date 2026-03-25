#!/bin/bash
visible=$(hyprctl monitors -j | jq '[.[] | select(.specialWorkspace.name == "special:music" or .specialWorkspace.name == "special:cmus")] | length')
exists=$(hyprctl workspaces -j | jq '[.[] | select(.name == "special:music" or .name == "special:cmus")] | length')

if [ "$visible" -gt 0 ]; then
    printf '{"text": "\uf001", "class": "visible", "tooltip": "Music (offen)"}\n'
elif [ "$exists" -gt 0 ]; then
    printf '{"text": "\uf001", "class": "hidden", "tooltip": "Music (versteckt)"}\n'
else
    printf '{"text": "\uf001", "class": "empty", "tooltip": "Music (nicht gestartet)"}\n'
fi
