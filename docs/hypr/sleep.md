# Sleep / Power Management

## Keybind

```ini
bind = $mod, F1, exec, systemctl suspend
```

---

## Modes

```bash
systemctl suspend       # RAM stays on, instant wake (keyboard/mouse)
systemctl hibernate     # RAM to disk, machine fully off, only power button wakes
systemctl hybrid-sleep  # both: RAM to disk + suspend
```

| Mode      | RAM       | Power draw | Wake            | Swap needed |
|-----------|-----------|------------|-----------------|-------------|
| suspend   | stays on  | minimal    | keyboard / mouse | no         |
| hibernate | to disk   | none       | power button    | yes         |
| hybrid    | both      | minimal    | keyboard / mouse | yes        |

---

## How it works

`systemctl suspend` ultimately writes to a kernel interface:

```bash
echo mem  > /sys/power/state   # suspend
echo disk > /sys/power/state   # hibernate
```

`/sys/power/state` is **not a real file** — it's part of `sysfs`, a virtual filesystem
the kernel exposes as an API. Writing to it calls a kernel function directly.

Available values:
```
mem    → Suspend to RAM (S3)
disk   → Suspend to Disk (S4)
freeze → Freeze processes, no actual sleep
```

### What systemd does additionally

Before the actual sleep, systemd coordinates:
1. Pausing running services
2. Setting locks (e.g. triggering Hyprlock before sleep)
3. Then → `/sys/power/state`

### Before systemd

`pm-utils` was the standard:
```bash
pm-suspend
pm-hibernate
```
Also just shell scripts that wrote to `/sys/power/state` in the end.
Even earlier: `acpid` with custom scripts in `/etc/acpi/` — very fragmented.

---

## Linux philosophy: Everything is a file

`/sys/` and `/proc/` are virtual filesystems — no real files on disk,
but kernel interfaces that look like files:

```bash
cat /proc/cpuinfo                              # CPU info, generated on the fly
cat /sys/class/backlight/*/brightness          # read brightness
echo 100 > /sys/class/backlight/*/brightness   # set brightness
echo mem > /sys/power/state                    # suspend
```

Unified API: read/write instead of proprietary syscalls.

---

## Auto-sleep on inactivity (hypridle)

```bash
sudo pacman -S hypridle
```

```ini
# ~/.config/hypr/hypridle.conf
listener {
    timeout = 300
    on-timeout = systemctl suspend
}
```
