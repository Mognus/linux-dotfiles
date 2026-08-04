#!/usr/bin/env bash
set -euo pipefail

# Distributions install the same GNOME agent under different library paths.
agent_paths=(
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
    /usr/libexec/polkit-gnome-authentication-agent-1
)

for agent in "${agent_paths[@]}"; do
    if [[ -x "$agent" ]]; then
        exec "$agent"
    fi
done

printf 'Error: no polkit-gnome authentication agent found\n' >&2
exit 1
