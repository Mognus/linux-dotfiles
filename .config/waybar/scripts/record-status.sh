#!/bin/bash
if pgrep -x wf-recorder > /dev/null; then
    printf '{"text": "\uf111", "class": "recording", "tooltip": "Aufnahme läuft"}\n'
else
    printf '{"text": "", "class": "", "tooltip": ""}\n'
fi
