#!/bin/bash
visible=$(hyprctl monitors -j | jq '[.[] | select(.specialWorkspace.name == "special:notes")] | length')
exists=$(hyprctl workspaces -j | jq '[.[] | select(.name == "special:notes")] | length')

if [ "$visible" -gt 0 ]; then
    printf '{"text": "\uf15c", "class": "visible", "tooltip": "Notes Scratchpad (offen)"}\n'
elif [ "$exists" -gt 0 ]; then
    printf '{"text": "\uf15c", "class": "hidden", "tooltip": "Notes Scratchpad (versteckt)"}\n'
else
    printf '{"text": "\uf15c", "class": "empty", "tooltip": "Notes Scratchpad (nicht gestartet)"}\n'
fi
