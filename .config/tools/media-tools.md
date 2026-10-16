# Media Tools

Media tooling is intentionally small and CLI-first.

## yt-dlp

`yt-dlp` config lives at `.config/yt-dlp/config`.

## Does

- Extracts audio
- Writes MP3 files
- Stores downloads under `~/Music/%(playlist_title)s/%(title)s.%(ext)s`

## Playback

- `mpv` handles video playback
- `playerctl` handles the media-key commands in Hyprland's Lua keybindings

## Workflow

Use `yt-dlp` for music downloads, `mpv` for direct playback, and `playerctl` for desktop integration.
