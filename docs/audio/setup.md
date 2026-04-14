# Audio Setup on Linux (PipeWire + USB Headset)

## Architecture

The Linux audio stack has grown historically and consists of several layers:

```
Apps (Firefox, mpv, Discord, ...)
        ↓
  PulseAudio API  ←→  pipewire-pulse   (compatibility layer)
  ALSA API        ←→  pipewire-alsa    (compatibility layer)
  JACK API        ←→  pipewire-jack    (compatibility layer, pro-audio)
        ↓
    PipeWire                            (central audio server)
        ↓
    WirePlumber                         (session manager, handles routing)
        ↓
    ALSA (Kernel)                       (talks directly to hardware)
        ↓
    Hardware (USB Headset, soundcard, HDMI, ...)
```

PipeWire is the hub — all apps land there regardless of which API they use. WirePlumber decides which device gets which stream.

---

## Trivia

- **ALSA** (Advanced Linux Sound Architecture) has been in the kernel since ~2001 and talks directly to hardware. Sufficient for simple use cases but no mixing across multiple apps.
- **PulseAudio** was the standard desktop sound server from ~2008 and handled mixing. Much Arch Wiki documentation still refers to PulseAudio.
- **PipeWire** has replaced both PulseAudio and JACK since ~2021. It is backwards-compatible — `pactl` (PulseAudio Control) still works because `pipewire-pulse` implements the same API.
- **WirePlumber** is the session manager for PipeWire — it decides which streams are routed to which devices.
- **USB Audio** works on Linux mostly without drivers because USB Audio Class is a standardized protocol supported directly by the kernel.
- `pactl` stands for "PulseAudio Control" — works 1:1 with PipeWire as long as `pipewire-pulse` is running.

---

## Packages

| Package | Purpose |
|---------|---------|
| `pipewire` | The audio server itself |
| `pipewire-pulse` | PulseAudio compatibility (Firefox, Discord, etc.) |
| `pipewire-alsa` | ALSA compatibility (`speaker-test`, `aplay`, etc.) |
| `pipewire-jack` | JACK compatibility (pro-audio, DAWs) |
| `wireplumber` | Session manager, routing logic |
| `alsa-utils` | CLI tools: `speaker-test`, `aplay`, `arecord` |

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber alsa-utils
```

---

## Setup

### 1. Enable services

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

Check status:
```bash
systemctl --user status pipewire pipewire-pulse wireplumber
```

### 2. Check hardware

```bash
cat /proc/asound/cards
```

Lists all sound cards recognized by the kernel. USB headsets appear here automatically.

### 3. Show PipeWire devices

```bash
pactl list sinks short      # output (headphones, speakers)
pactl list sources short    # input (microphone)
```

Device names look like:
```
alsa_output.usb-<device>-00.analog-stereo
alsa_input.usb-<device>-00.analog-stereo
```

Built from: `alsa_output` + USB device name + profile (`analog-stereo`, `mono-fallback`, ...)

### 4. Set as default

```bash
pactl set-default-sink   <sink-name>
pactl set-default-source <source-name>
```

Verify:
```bash
pactl info | grep -E "Default Sink|Default Source"
```

### 5. Volume

```bash
pactl set-sink-volume   @DEFAULT_SINK@   80%
pactl set-source-volume @DEFAULT_SOURCE@ 70%

# Mute toggle
pactl set-sink-mute   @DEFAULT_SINK@   toggle
pactl set-source-mute @DEFAULT_SOURCE@ toggle
```

### 6. Test

```bash
# Output
speaker-test -t wav -c 2 -l 1

# Microphone (record 5s, then play back)
arecord -d 5 /tmp/test.wav && aplay /tmp/test.wav
```

---

## Persistent (Hyprland)

In `~/.config/hypr/hyprland.conf`:

```
exec-once = pactl set-default-sink   <sink-name>
exec-once = pactl set-default-source <source-name>
```

### Volume keybindings

```
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume   @DEFAULT_SINK@ +5%
bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume   @DEFAULT_SINK@ -5%
bind = , XF86AudioMute,        exec, pactl set-sink-mute     @DEFAULT_SINK@ toggle
bind = , XF86AudioMicMute,     exec, pactl set-source-mute   @DEFAULT_SOURCE@ toggle
```

---

## Debug Workflow

**Bottom to top:**

```
1. Hardware detected?   →  cat /proc/asound/cards
2. PipeWire running?    →  systemctl --user status pipewire pipewire-pulse
3. Device visible?      →  pactl list sinks short
4. Default set?         →  pactl info | grep Default
5. Stream arriving?     →  pactl list sink-inputs short
6. Restart app?         →  e.g. Firefox after pipewire-pulse start
```

Logs:
```bash
journalctl --user -u pipewire -e
journalctl --user -u pipewire-pulse -e
dmesg | grep -i audio
```
