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
- `ThemePaths.qml` — shared QML paths to the local `appearancectl` binary and
  `~/.local/state/dotfiles-theme`, the writer's fixed state directory.
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
  - `Breadcrumbs.qml` — location header with a configurable root label, e.g.
    `× SETTINGS / Appearance / Theme`; the × reports a close request.
  - `SearchableList.qml` — shared name filtering, selection, keyboard and
    search field for Settings, Theme and Wallpaper. Entries provide `name`; activation
    passes the original entry to the page. Optional ruled section headings group
    matching entries without adding navigation levels. Theme supplies its own two-line row.
  - `SearchFooter.qml` — `/ cy` search line; it only types and hands every
    key to its `keyTargets` first, so the owner decides what keys drive.
    The settings, wallpaper and theme views open it on `/`.
  - `launcher/AppLauncher.qml` — GNOME-style grid of the desktop apps with an
    always active search; arrows or Ctrl+hjkl move, Enter starts, Esc closes.
  - `launcher/WindowSwitcher.qml` — open windows of every workspace on the
    left, grouped by app under an icon header, a live view of the highlighted
    one on the right; same search.
  - `launcher/ClipboardHistory.qml` — cliphist entries, newest first, with
    the full text or image of the highlighted one on the right; same search,
    Enter copies the entry back.
  - `settings/` — the settings menu (Super+G), with all categories visible together:
    - `SettingsMenu.qml` — General (Audio, Notifications, Session), Appearance (Theme, Wallpaper, Adjustments), and
      Launcher (Applications, Windows, Clipboard). One definition supplies names,
      components, dimensions and actions. Search removes empty categories; launcher
      actions open the existing overlays through the same functions as their keybinds.
      The TUI-style start view has an opaque theme-colored frame, an inverted
      selection bar with a `>` marker, launcher key hints and a pinned keyboard legend.
    - `AudioPage.qml` — compact output and microphone cards inside a bounded
      scroll area, with Pipewire status pinned below.
    - `NotificationsPage.qml` — do-not-disturb, default timeout (3/5/10 seconds),
      active count and dismiss-all controls. Critical notifications bypass DND.
      These preferences apply to the current shell session.
    - `SessionPage.qml` — searchable lock, logout, restart and shutdown actions.
      Locking uses `loginctl lock-session` and the existing Hypridle handler.
    - `SettingsButton.qml` — square buttons with Tab focus and Enter/Space activation.
    - `AdjustmentsPage.qml` / `SettingSlider.qml` — terminal opacity, font size
      and padding, saved on release through the local Rust writer. Reset restores
      their defaults without changing the theme.
    - `ThemePage.qml` — searchable palette names with terminal and browser
      color previews; highlighting previews a palette, Enter applies it.
    - `theme/TerminalPreview.qml` / `theme/BrowserPreview.qml` — illustrative
      previews that read the highlighted palette independently of the active theme.
    - `WallpaperPage.qml` — searchable files from `~/.config/wallpapers` on
      the left, an aspect-preserving preview on the right; Enter sets the
      highlighted image through `awww`.
  - `AudioControl.qml` — output/input card with mute, volume percentage,
    a draggable slider, wheel adjustment in 2% steps and optional presets.
  - `NotificationPopups.qml` — retro notification popups top right: square
    borders, an inverted app-name header and VGA text. Titles use up to two
    lines, bodies up to four with ellipsis. Normal ones expire after 5s,
    critical ones have a red `!` header and stay; a click closes one.
  - `TuxMascot.qml` — left/right mascot panel.
- `lib/Audio.js` — Pipewire audio helper functions.
- `services/Appearance.qml` — watches the shared terminal TOML, reads the current
  values through `appearancectl get` and queues writes to its local binary.
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
  red danger color. Alacritty and GTK colors are generated by `appearancectl`.
- **Audio** — volume via Pipewire (`Quickshell.Services.Pipewire`).
- **Battery** — percentage in the bar when a laptop battery is present; low charge
  is red unless charging.
- **Recording indicator** — shows when a screen recording is active.
- **Notifications** — replaces Dunst, colored by the current theme. General >
  Notifications controls do-not-disturb and the default popup duration; app-specified
  timeouts still take precedence (in milliseconds; zero disables expiry), and
  critical messages remain until dismissed.
- **Session** — General > Session offers locking, logout, restart and shutdown.
- **Tux mascot** — animated, can be toggled.

## Requirements

Build the local appearance writer once with
`make -C ~/dotfiles/tools/appearancectl` (Rust 1.89+, Cargo and Make). It is used
for theme changes, login restoration and the terminal adjustment sliders.

- `quickshell`
- Hyprland (uses `Quickshell.Hyprland`)
- Pipewire (uses `Quickshell.Services.Pipewire`)
- UPower for the laptop battery indicator (`Quickshell.Services.UPower`)
- `awww` for wallpapers; `dconf` for GTK theme preferences
- `cliphist` and `wl-clipboard` for clipboard history; `wf-recorder` for recording

## Run

```bash
qs -p "$HOME/.config/quickshell"
```

Started automatically from Hyprland's native Lua autostart module.
