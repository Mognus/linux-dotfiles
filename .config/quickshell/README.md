# Quickshell

My desktop shell for Hyprland, built with [Quickshell](https://quickshell.outfoxxed.me/)
(QtQuick/QML). Replaces the previous EWW setup.

## Structure

- `shell.qml` — root state, timers, IPC, process hooks, and component wiring.
- `TopBar.qml` — workspace strip, clock, recording indicator, volume text, quick settings trigger, special workspace buttons.
- `QuickSettingsPanel.qml` — right side quick settings panel.
- `AudioControl.qml` — reusable output/input volume control.
- `TuxMascot.qml` — left/right mascot panel.
- `lib/Audio.js` — Pipewire audio helper functions.
- `assets/` — Tux mascot sprites (`tux*_{tiny,small,hires}.gif`, `ai/`).

## What it does

- **Workspaces** — live Hyprland workspaces plus named *special* workspaces
  (term, files, music, cmus, notes, discord, firefox), each with its own accent.
- **Clock** — `hh:mm`, top center.
- **Quick settings** — togglable panel.
- **Audio** — volume via Pipewire (`Quickshell.Services.Pipewire`).
- **Recording indicator** — shows when a screen recording is active.
- **Tux mascot** — animated, can be toggled.

## Requirements

- `quickshell`
- Hyprland (uses `Quickshell.Hyprland`)
- Pipewire (uses `Quickshell.Services.Pipewire`)

## Run

```bash
qs -c quickshell        # or: quickshell -c quickshell
```

Started automatically from the Hyprland config (`exec-once`).
