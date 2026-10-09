# Quickshell

My desktop shell for Hyprland, built with [Quickshell](https://quickshell.outfoxxed.me/)
(QtQuick/QML). Replaces the previous EWW setup.

## Structure

- `shell.qml` — composition root: wires `modules/` components together, keeps no
  state of its own beyond the Pipewire object tracker.
- `services/` — singletons holding all shared state and logic:
  - `ShellState.qml` — panel visibility (bottom bar, workspace HUD, tux) and the
    one open overlay (settings menu, app launcher or window switcher; opening
    one closes the other), plus the IPC handlers that toggle them.
  - `Workspaces.qml` — Hyprland workspace/special-workspace queries and the
    active-special-workspace tracking (seeded from `Hyprland.monitors`, kept
    live via `rawEvent`).
  - `Time.qml` — clock.
  - `Recording.qml` — `wf-recorder` status/toggle.
- `modules/` — UI panels, purely presentational, bound to the services above:
  - `BottomBar.qml` — workspace strip, clock, recording indicator, volume text,
    settings menu trigger, special workspace buttons.
  - `WorkspaceHud.qml` — compact workspace-only overlay.
  - `Menu.qml` / `MenuEntry.qml` — rofi-style list of entries; opening
    one swaps the list for the entry's page, or fires its `triggered` signal
    when it has none. A page can be another Menu, which makes a sub menu.
    Its `path` lists the titles opened so far, sub menus included.
  - `Breadcrumbs.qml` — `× ~ / Theme / Colors` header showing a Menu's
    path; the × reports a close request.
  - `SearchFooter.qml` — `/ cy` search line; it only types and hands every
    key to its `keyTargets` first, so the owner decides what keys drive. A
    Menu opens it on `/`.
  - `launcher/AppLauncher.qml` — GNOME-style grid of the desktop apps with an
    always active search; arrows or Ctrl+hjkl move, Enter starts, Esc closes.
  - `launcher/WindowSwitcher.qml` — open windows of every workspace on the
    left, grouped by app under an icon header, a live view of the highlighted
    one on the right; same search.
  - `settings/` — the settings menu (Super+G), laid out like the menu tree:
    - `SettingsMenu.qml` — the window and the top entries.
    - `AudioPage.qml` — audio settings page.
    - `menus/ThemeMenu.qml` — theme sub menu.
    - `menus/theme/WallpaperMenu.qml` — one entry per image in
      `~/.config/wallpapers`, Enter sets it through `awww`.
    - `menus/theme/ColorsMenu.qml` — one entry per palette in
      `~/.config/themes/palettes`, Enter runs `theme-switcher.sh`.
  - `AudioControl.qml` — reusable output/input volume control.
  - `TuxMascot.qml` — left/right mascot panel.
- `lib/Audio.js` — Pipewire audio helper functions.
- `lib/Navigation.js` — which direction a key means next to a search field:
  arrows or Ctrl+hjkl.
- `assets/` — animated angel/devil Tux sprites.

## What it does

- **Workspaces** — live Hyprland workspaces plus named *special* workspaces
  (term, files, music, notes, discord, firefox), each with its own accent.
- **Clock** — `hh:mm`, top center.
- **Settings menu** — centered rofi-style menu on Super+G.
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
