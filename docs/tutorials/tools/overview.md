# Tools Overview

This topic groups together small but practical supporting tools used in the wider setup.

## Main files

- `.config/yt-dlp/config`
- `packages.txt`

## What this topic covers

- Utility packages that support the environment
- Tool-specific defaults
- Lightweight command-line helpers outside the main shell or desktop topics

## Current setup details

### yt-dlp

The current `yt-dlp` config is tuned for music downloads:

- extract audio only
- output format: `mp3`
- save files to `~/Music/%(playlist_title)s/%(title)s.%(ext)s`

That means playlist downloads are automatically grouped into a dedicated folder structure.

### packages.txt

`packages.txt` acts as the broad inventory for the environment. It is not just a random dump of installed software — it is grouped by purpose, for example:

- shell
- editor
- terminal
- Wayland / desktop
- Wayland tools
- audio
- Bluetooth
- fonts
- apps
- dev languages
- containers
- media
- general tools
- AUR packages

This makes the file useful both as a rebuild checklist and as a high-level map of what the system depends on.

## Practical idea

Not every useful piece of the setup deserves its own major section. This topic is meant for supporting tools that still matter in day-to-day usage, even if they are not the centerpiece of the workflow.
