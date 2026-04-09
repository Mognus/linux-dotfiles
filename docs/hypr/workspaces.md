# Hyprland Named Workspaces

## How it works

Named workspaces involve two files that must stay in sync:

```
hyprland.conf        →  defines workspace IDs + names + persistence
waybar/config        →  maps names to icons, displays them in the bar
```

Hyprland assigns each workspace a numeric ID **and** a human-readable name.
Waybar reads those names from Hyprland and looks them up in `format-icons`.

```
hyprland.conf                          waybar/config
─────────────────────────────          ──────────────────────────────
workspace = 1, defaultName:code   →    "format-icons": { "code": "" }
workspace = 2, defaultName:test   →    "format-icons": { "test": "" }
...                                    ...
```

The bar displays: `{icon} {name}` → e.g. `  code`

---

## Key details

### hyprland.conf — workspace rules

```ini
workspace = ID, defaultName:NAME, persistent:true
```

- `defaultName:NAME` — sets the workspace name on creation. This is the correct
  keyword — `name:` does NOT work.
- `persistent:true` — workspace exists even when empty (no windows open).
- Numeric keybinds (`workspace, 1`) still work alongside named workspaces.

### waybar/config — workspace module

```json
"hyprland/workspaces": {
    "format": "{icon} {name}",
    "persistent-workspaces": { "*": [1, 2, 3, 4, 5, 6] },
    "format-icons": {
        "code":  "",
        "test":  "",
        ...
    }
}
```

- `persistent-workspaces` must use **numeric IDs** (not names) — otherwise
  Waybar creates duplicate workspace entries.
- `format-icons` keys are workspace **names** (as set by `defaultName:`).
- `{name}` in format string = workspace name from Hyprland.
- `{icon}` = matched icon from `format-icons`.

---

## Current workspace layout

| ID | Name  | Icon | Keybind        |
|----|-------|------|----------------|
| 1  | code  |     | SUPER+1 / +C   |
| 2  | test  |     | SUPER+2 / +Q   |
| 3  | flow  |     | SUPER+3 / +F   |
| 4  | voice |     | SUPER+4 / +V   |
| 5  | ai    |     | SUPER+5 / +A   |
| 6  | term  |     | SUPER+6 / +T   |

Icons are from [Nerd Fonts](https://www.nerdfonts.com/) (JetBrainsMono NF v3).

---

## Gotchas

- After changing `hyprland.conf` workspace rules: `hyprctl reload` + restart Waybar.
- After changing `waybar/config`: `pkill waybar && waybar &`.
- Hyprland only applies `defaultName:` on first workspace creation — existing
  workspaces keep their old name until the next full Hyprland restart.

---

> **Keep this file up to date.**
> Any change to workspace names, IDs, icons, or keybinds in `hyprland.conf`
> or `waybar/config` must be reflected here.
