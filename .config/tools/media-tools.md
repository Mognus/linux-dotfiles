# Media Tools

Media tooling is intentionally small and CLI-first.

## yt-dlp

No global presets: choose the download behavior explicitly for each invocation.

```sh
yt-dlp "URL"
yt-dlp -x --audio-format mp3 "URL"
```

## Recording

No toggle script or recording shortcut. Start and stop from the terminal:

```sh
mkdir -p ~/Videos
wf-recorder -f ~/Videos/aufnahme.mp4
```

Ctrl+C stops the recording.

## Playback

- `mpv` handles video playback
- `playerctl` handles the media-key commands in Hyprland's Lua keybindings

## Workflow

Use `yt-dlp` for downloads, `mpv` for direct playback, and `playerctl` for desktop integration.
