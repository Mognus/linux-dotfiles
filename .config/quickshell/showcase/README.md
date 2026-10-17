# Quickshell

My desktop shell for Hyprland, built with [Quickshell](https://quickshell.outfoxxed.me/)
(QtQuick/QML). Replaces the previous EWW setup.

## Structure

- `lock.qml` — lock screen, run as its own process (`qs -n -d -p
  ~/.config/quickshell/lock.qml`) so a shell bug or hot reload can not unlock
  the session: blurred wallpaper, clock, password checked through PAM
  (`quickshell-lock` service from the NixOS config).
- `shell.qml` — composition root: wires `modules/` components together, keeps no
  state of its own beyond the Pipewire object tracker.
- `Fonts.qml` — shared font family and pixel sizes for all shell text, including
  the bar, launchers, settings, notifications and lock screen.
- `LauncherStyle.qml` — shared spacing, icons and panel dimensions for the app
  launcher, window switcher and clipboard history. Colors come from `Colors.qml`.
- `services/` — singletons holding all shared state and logic:
  - `ShellState.qml` — panel visibility (bottom bar, workspace HUD, tux) and the
    one open overlay (settings menu, app launcher, window switcher or clipboard
    history; opening one closes the other), plus the IPC handlers that toggle
    them.
  - `Workspaces.qml` — Hyprland workspace/special-workspace queries and the
    active-special-workspace tracking (seeded from `Hyprland.monitors`, kept
    live via `rawEvent`).
  - `Time.qml` — clock.
  - `Battery.qml` — laptop battery percentage and charging state through UPower;
    hidden on machines without a laptop battery.
  - `Recording.qml` — `wf-recorder` status/toggle.
  - `Notifications.qml` — notification daemon: owns
    `org.freedesktop.Notifications` on D-Bus and keeps the open notifications.
- `modules/` — UI panels, purely presentational, bound to the services above:
  - `OverlayWindow.qml` — shared full-screen backdrop for settings and launchers:
    50% black with Hyprland background blur, keeping the panel sharp and centered.
  - `BottomBar.qml` — workspace strip, clock, recording indicator, volume text,
    laptop battery percentage, settings menu trigger, special workspace buttons.
  - `WorkspaceHud.qml` — compact workspace-only overlay.
  - `Breadcrumbs.qml` — `× ~ / Theme` header showing the current settings
    page; the × reports a close request.
  - `SearchFooter.qml` — `/ cy` search line; it only types and hands every
    key to its `keyTargets` first, so the owner decides what keys drive.
    The wallpaper view opens it on `/`.
  - `launcher/AppLauncher.qml` — GNOME-style grid of the desktop apps with an
    always active search; arrows or Ctrl+hjkl move, Enter starts, Esc closes.
  - `launcher/WindowSwitcher.qml` — open windows of every workspace on the
    left, grouped by app under an icon header, a live view of the highlighted
    one on the right; same search.
  - `launcher/ClipboardHistory.qml` — cliphist entries, newest first, with
    the full text or image of the highlighted one on the right; same search,
    Enter copies the entry back.
  - `settings/` — the settings menu (Super+G), with one level of navigation:
    - `SettingsMenu.qml` — the window, current page and top entries.
    - `AudioPage.qml` — compact output and microphone cards inside a bounded
      scroll area, with Pipewire status pinned below.
    - `ThemePage.qml` — palette selection with terminal and browser color
      previews; highlighting previews a palette, Enter applies it.
    - `theme/TerminalPreview.qml` / `theme/BrowserPreview.qml` — illustrative
      previews that read the highlighted palette independently of the active theme.
    - `WallpaperPage.qml` — searchable files from `~/.config/wallpapers` on
      the left, an aspect-preserving preview on the right; Enter sets the
      highlighted image through `awww`.
  - `AudioControl.qml` — output/input card with mute, volume percentage,
    a draggable slider, wheel adjustment in 2% steps and optional presets.
  - `NotificationPopups.qml` — notification popups top right; normal ones
    expire after 5s, critical ones stay, a click closes one.
  - `TuxMascot.qml` — left/right mascot panel.
- `lib/Audio.js` — Pipewire audio helper functions.
- `lib/Navigation.js` — shared keyboard recognition: arrows or Ctrl+hjkl in
  search fields, arrows or plain hjkl in lists, plus confirm and back keys.
- `assets/` — animated angel/devil Tux sprites.

## What it does

- **Workspaces** — live Hyprland workspaces plus named *special* workspaces
  (term, files, music, notes, discord, firefox), highlighted with the shared accent.
- **Clock** — `hh:mm`, centered in the bottom bar.
- **Settings menu** — centered keyboard-driven menu on Super+G.
- **Themes** — White, Light Gray, Dark Gray, Gruvbox Light, Retro Dark,
  Retro Cyan and Retro Pink palettes from `~/.config/themes/palettes`.
  Light Gray restores the original pale gray appearance with a dark terminal;
  White uses a white background and terminal. Retro Dark is the black variant.
  Gruvbox Light uses a warm beige background and a light terminal.
  Shell backgrounds and text follow the palette, with a shared green accent and
  red danger color. Alacritty and GTK colors are generated by the theme switcher.
- **Audio** — volume via Pipewire (`Quickshell.Services.Pipewire`).
- **Battery** — percentage in the bar when a laptop battery is present; low charge
  is red unless charging.
- **Recording indicator** — shows when a screen recording is active.
- **Notifications** — replaces Dunst, colored by the current theme.
- **Tux mascot** — animated, can be toggled.

## Requirements

- `quickshell`
- Hyprland (uses `Quickshell.Hyprland`)
- Pipewire (uses `Quickshell.Services.Pipewire`)
- UPower for the laptop battery indicator (`Quickshell.Services.UPower`)
- `awww` for wallpapers; `jq` and `dconf` for the theme switcher
- `cliphist` and `wl-clipboard` for clipboard history; `wf-recorder` for recording

## Run

```bash
qs -p "$HOME/.config/quickshell"
```

Started automatically from Hyprland's native Lua autostart module.
