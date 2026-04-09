#!/bin/bash
visible=$(hyprctl monitors -j | jq '[.[] | select(.specialWorkspace.name == "special:term")] | length')
exists=$(hyprctl workspaces -j | jq '[.[] | select(.name == "special:term")] | length')

if [ "$visible" -gt 0 ]; then
    printf '{"text": "\uf120", "class": "visible", "tooltip": "Terminal (offen)"}\n'
elif [ "$exists" -gt 0 ]; then
    printf '{"text": "\uf120", "class": "hidden", "tooltip": "Terminal (versteckt)"}\n'
else
    printf '{"text": "\uf120", "class": "empty", "tooltip": "Terminal (nicht gestartet)"}\n'
fi
