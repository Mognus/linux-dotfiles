#!/bin/bash
visible=$(hyprctl monitors -j | jq '[.[] | select(.specialWorkspace.name == "special:cmus")] | length')
exists=$(hyprctl workspaces -j | jq '[.[] | select(.name == "special:cmus")] | length')

if [ "$visible" -gt 0 ]; then
    printf '{"text": "\uf9c1", "class": "visible", "tooltip": "cmus (offen)"}\n'
elif [ "$exists" -gt 0 ]; then
    printf '{"text": "\uf9c1", "class": "hidden", "tooltip": "cmus (versteckt)"}\n'
else
    printf '{"text": "\uf9c1", "class": "empty", "tooltip": "cmus (nicht gestartet)"}\n'
fi
