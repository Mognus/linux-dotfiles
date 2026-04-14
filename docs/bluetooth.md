# Bluetooth (bluetoothctl)

## Service

```bash
sudo systemctl enable --now bluetooth
systemctl status bluetooth
```

---

## Connect a device

```bash
bluetoothctl

scan on
scan off                          # stop once device appears

pair AA:BB:CC:DD:EE:FF
connect AA:BB:CC:DD:EE:FF
trust AA:BB:CC:DD:EE:FF           # enables auto-connect
```

---

## Overview

```bash
devices                           # all known devices
devices Connected                 # currently connected
info AA:BB:CC:DD:EE:FF            # device details
show                              # controller status
```

---

## Disconnect / remove

```bash
disconnect AA:BB:CC:DD:EE:FF
remove AA:BB:CC:DD:EE:FF          # forget device, requires re-pairing
```

---

## Auto-connect not working?

After `trust`, the device connects automatically when in range. If it doesn't:

```bash
info AA:BB:CC:DD:EE:FF            # check: Trusted: yes, Paired: yes
```

---

## Quick reference

| Command | Action |
|---|---|
| `scan on/off` | Start/stop scanning |
| `devices` | List known devices |
| `pair <MAC>` | Pair device |
| `connect <MAC>` | Connect |
| `disconnect <MAC>` | Disconnect |
| `trust <MAC>` | Enable auto-connect |
| `untrust <MAC>` | Disable auto-connect |
| `remove <MAC>` | Forget device |
| `show` | Controller info |
| `quit` | Exit bluetoothctl |
