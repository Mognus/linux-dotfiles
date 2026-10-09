# Quickshell

My desktop shell for Hyprland, built with [Quickshell](https://quickshell.outfoxxed.me/)
(QtQuick/QML). Replaces the previous EWW setup.

## Structure

- `shell.qml` — composition root: wires `modules/` components together, keeps no
  state of its own beyond the Pipewire object tracker.
- `services/` — singletons holding all shared state and logic:
  - `ShellState.qml` — panel visibility (bottom bar, workspace HUD, tux, settings
    menu) and the IPC handlers that toggle them.
  - `Workspaces.qml` — Hyprland workspace/special-workspace queries and the
    active-special-workspace tracking (seeded from `Hyprland.monitors`, kept
    live via `rawEvent`).
  - `Time.qml` — clock.
  - `Recording.qml` — `wf-recorder` status/toggle.
- `modules/` — UI panels, purely presentational, bound to the services above:
  - `BottomBar.qml` — workspace strip, clock, recording indicator, volume text,
    settings menu trigger, special workspace buttons.
  - `WorkspaceHud.qml` — compact workspace-only overlay.
  - `Launcher.qml` / `LauncherEntry.qml` — rofi-style list of entries; opening
    one swaps the list for the entry's page, or fires its `triggered` signal
    when it has none. A page can be another Launcher, which makes a sub menu.
  - `settings/` — the settings menu (Super+G), laid out like the menu tree:
    - `SettingsMenu.qml` — the window and the top entries.
    - `AudioPage.qml` — audio settings page.
    - `launchers/ThemeLauncher.qml` — theme sub menu.
    - `launchers/theme/WallpaperLauncher.qml` — one entry per image in
      `~/.config/wallpapers`, Enter sets it through `awww`.
    - `launchers/theme/ColorsLauncher.qml` — one entry per palette in
      `~/.config/themes/palettes`, Enter runs `theme-switcher.sh`.
  - `AudioControl.qml` — reusable output/input volume control.
  - `TuxMascot.qml` — left/right mascot panel.
- `lib/Audio.js` — Pipewire audio helper functions.
- `assets/` — animated angel/devil Tux sprites.

## What it does

- **Workspaces** — live Hyprland workspaces plus named *special* workspaces
  (term, files, music, notes, discord, firefox), each with its own accent.
- **Clock** — `hh:mm`, top center.
- **Settings menu** — centered launcher-style menu on Super+G.
- **Audio** — volume via Pipewire (`Quickshell.Services.Pipewire`).
- **Recording indicator** — shows when a screen recording is active.
- **Tux mascot** — animated, can be toggled.

## Requirements

- `quickshell`
- Hyprland (uses `Quickshell.Hyprland`)
- Pipewire (uses `Quickshell.Services.Pipewire`)

## Run

```bash
qs -p "$HOME/.config/quickshell"
```

Started automatically from Hyprland's native Lua autostart module.
