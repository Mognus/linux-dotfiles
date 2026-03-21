# Sleep / Power Management

## Keybind

```ini
bind = $mod, F1, exec, systemctl suspend
```

---

## Modes

```bash
systemctl suspend       # RAM bleibt an, sofortiges Aufwachen (Tastatur/Maus)
systemctl hibernate     # RAM auf Disk, Rechner komplett aus, nur Power-Knopf weckt
systemctl hybrid-sleep  # beides: RAM auf Disk + suspend
```

| Mode      | RAM       | Stromverbrauch | Aufwachen       | Swap nötig |
|-----------|-----------|----------------|-----------------|------------|
| suspend   | bleibt an | minimal        | Tastatur / Maus | nein       |
| hibernate | auf Disk  | null           | Power-Knopf     | ja         |
| hybrid    | beides    | minimal        | Tastatur / Maus | ja         |

---

## Wie es funktioniert

`systemctl suspend` schreibt letztendlich in ein Kernel-Interface:

```bash
echo mem  > /sys/power/state   # suspend
echo disk > /sys/power/state   # hibernate
```

`/sys/power/state` ist **keine echte Datei** — es ist Teil von `sysfs`, einem
virtuellen Dateisystem das der Kernel als API exponiert. Reinschreiben ruft
direkt eine Kernel-Funktion auf.

Verfügbare Werte:
```
mem    → Suspend to RAM (S3)
disk   → Suspend to Disk (S4)
freeze → Prozesse einfrieren, kein echter Sleep
```

### Was systemd zusätzlich macht

Vor dem eigentlichen Sleep koordiniert systemd:
1. Laufende Services pausieren
2. Locks setzen (z.B. Hyprlock triggern vor dem Sleep)
3. Dann erst → `/sys/power/state`

### Vor systemd

`pm-utils` war der Standard:
```bash
pm-suspend
pm-hibernate
```
Auch nur Shell-Skripte die am Ende dasselbe in `/sys/power/state` geschrieben haben.
Noch früher: `acpid` mit eigenen Skripten in `/etc/acpi/` — sehr fragmentiert.

---

## Linux-Philosophie: Alles ist eine Datei

`/sys/` und `/proc/` sind virtuelle Dateisysteme — keine echten Dateien auf Disk,
sondern Kernel-Interfaces die als Dateien aussehen:

```bash
cat /proc/cpuinfo                              # CPU-Info, on-the-fly generiert
cat /sys/class/backlight/*/brightness          # Helligkeit lesen
echo 100 > /sys/class/backlight/*/brightness   # Helligkeit setzen
echo mem > /sys/power/state                    # suspend
```

Einheitliche API: lesen/schreiben statt proprietäre Syscalls.

---

## Automatisch bei Inaktivität (hypridle)

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
