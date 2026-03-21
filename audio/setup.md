# Audio Setup unter Linux (PipeWire + USB Headset)

## Architektur

Der Linux-Audio-Stack ist historisch gewachsen und besteht aus mehreren Schichten:

```
Apps (Firefox, mpv, Discord, ...)
        ↓
  PulseAudio API  ←→  pipewire-pulse   (Kompatibilitätsschicht)
  ALSA API        ←→  pipewire-alsa    (Kompatibilitätsschicht)
  JACK API        ←→  pipewire-jack    (Kompatibilitätsschicht, pro-audio)
        ↓
    PipeWire                            (zentraler Audio-Server)
        ↓
    WirePlumber                         (Session-Manager, entscheidet Routing)
        ↓
    ALSA (Kernel)                       (spricht direkt mit Hardware)
        ↓
    Hardware (USB Headset, Soundkarte, HDMI, ...)
```

PipeWire ist der Hub — alle Apps landen dort, egal welche API sie nutzen. WirePlumber entscheidet welches Gerät welchen Stream bekommt.

---

## Trivia

- **ALSA** (Advanced Linux Sound Architecture) ist seit ~2001 im Kernel und spricht direkt mit der Hardware. Für einfache Anwendungsfälle reicht es, aber kein Mixing über mehrere Apps hinweg.
- **PulseAudio** war ab ~2008 der Standard-Sound-Server auf Desktop-Linux und hat das Mixing übernommen. Viel Arch-Wiki-Doku zeigt noch PulseAudio.
- **PipeWire** ersetzt seit ~2021 sowohl PulseAudio als auch JACK. Es ist rückwärtskompatibel — d.h. `pactl` (PulseAudio Control) funktioniert weiterhin, weil `pipewire-pulse` dieselbe API implementiert.
- **WirePlumber** ist der Session-Manager für PipeWire — er entscheidet welche Streams zu welchen Geräten geroutet werden.
- **USB Audio** funktioniert unter Linux meist ohne Treiber, weil USB Audio Class ein standardisiertes Protokoll ist das der Kernel direkt unterstützt.
- `pactl` heißt "PulseAudio Control" — funktioniert aber 1:1 mit PipeWire solange `pipewire-pulse` läuft.

---

## Pakete

| Paket | Zweck |
|-------|-------|
| `pipewire` | Der Audio-Server selbst |
| `pipewire-pulse` | PulseAudio-Kompatibilität (für Firefox, Discord, etc.) |
| `pipewire-alsa` | ALSA-Kompatibilität (für `speaker-test`, `aplay`, etc.) |
| `pipewire-jack` | JACK-Kompatibilität (pro-audio, DAWs) |
| `wireplumber` | Session-Manager, Routing-Logik |
| `alsa-utils` | CLI-Tools: `speaker-test`, `aplay`, `arecord` |

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber alsa-utils
```

---

## Setup

### 1. Services aktivieren

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

Status prüfen:
```bash
systemctl --user status pipewire pipewire-pulse wireplumber
```

### 2. Hardware prüfen

```bash
cat /proc/asound/cards
```

Gibt alle vom Kernel erkannten Soundkarten aus. USB-Headsets tauchen hier automatisch auf.

### 3. PipeWire-Geräte anzeigen

```bash
pactl list sinks short      # Ausgabe (Kopfhörer, Lautsprecher)
pactl list sources short    # Eingabe (Mikrofon)
```

Gerätenamen sehen z.B. so aus:
```
alsa_output.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo
alsa_input.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo
```

Aufgebaut aus: `alsa_output` + USB-Gerätename + Profil (`analog-stereo`, `mono-fallback`, ...)

### 4. Als Standard setzen

```bash
pactl set-default-sink   alsa_output.usb-DEIN_HEADSET...
pactl set-default-source alsa_input.usb-DEIN_HEADSET...
```

Prüfen:
```bash
pactl info | grep -E "Default Sink|Default Source"
```

### 5. Lautstärke

```bash
pactl set-sink-volume   @DEFAULT_SINK@   80%
pactl set-source-volume @DEFAULT_SOURCE@ 70%

# Mute toggle
pactl set-sink-mute   @DEFAULT_SINK@   toggle
pactl set-source-mute @DEFAULT_SOURCE@ toggle
```

### 6. Testen

```bash
# Ausgabe
speaker-test -t wav -c 2 -l 1

# Mikro (5 Sek aufnehmen, dann abspielen)
arecord -d 5 /tmp/test.wav && aplay /tmp/test.wav
```

---

## Dauerhaft (Hyprland)

In `~/.config/hypr/hyprland.conf`:

```
exec-once = pactl set-default-sink   alsa_output.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo
exec-once = pactl set-default-source alsa_input.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo
```

### Lautstärke-Keybindings

```
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume   @DEFAULT_SINK@ +5%
bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume   @DEFAULT_SINK@ -5%
bind = , XF86AudioMute,        exec, pactl set-sink-mute     @DEFAULT_SINK@ toggle
bind = , XF86AudioMicMute,     exec, pactl set-source-mute   @DEFAULT_SOURCE@ toggle
```

---

## Debug-Workflow

**Von unten nach oben:**

```
1. Hardware erkannt?    →  cat /proc/asound/cards
2. PipeWire läuft?      →  systemctl --user status pipewire pipewire-pulse
3. Gerät sichtbar?      →  pactl list sinks short
4. Standard gesetzt?    →  pactl info | grep Default
5. Stream kommt an?     →  pactl list sink-inputs short
6. App neu starten?     →  z.B. Firefox nach pipewire-pulse-Start neu starten
```

Logs:
```bash
journalctl --user -u pipewire -e
journalctl --user -u pipewire-pulse -e
dmesg | grep -i audio
```

---

## Mein Setup (HyperX 7.1)

- Karte: `Kingston HyperX 7.1 Audio` → ALSA-Karte 3
- Sink:   `alsa_output.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo`
- Source: `alsa_input.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo`
