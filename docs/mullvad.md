# Mullvad VPN

## Setup

```bash
sudo systemctl enable --now mullvad-daemon
mullvad account login $(gpg -d ~/.local/share/secrets/mullvad.gpg)
mullvad connect
```

Account-Number liegt verschlüsselt in `~/.local/share/secrets/mullvad.gpg`.

## Basic Usage

```bash
mullvad status        # connection status
mullvad connect       # connect
mullvad disconnect    # disconnect
mullvad account get   # show account info + expiry
```

## Kill Switch

```bash
mullvad lockdown-mode set on   # block all traffic when VPN is disconnected
mullvad lockdown-mode set off
```

## Relay Selection

```bash
mullvad relay list                          # all available servers
mullvad relay set location de               # country (Germany)
mullvad relay set location de ber           # country + city (Berlin)
mullvad relay set location de ber mul-de-ber-wg-001  # specific server
mullvad relay set tunnel-protocol wireguard # force WireGuard (default)
```

## DNS

```bash
mullvad dns set default          # use Mullvad DNS (default)
mullvad dns set custom 1.1.1.1   # custom DNS
mullvad dns get                  # show current DNS
```

## Auto-connect

```bash
mullvad auto-connect set on    # connect automatically on daemon start
mullvad auto-connect set off
```

## Split Tunneling

Exclude specific apps from the VPN:

```bash
mullvad split-tunnel add /usr/bin/firefox
mullvad split-tunnel list
mullvad split-tunnel delete /usr/bin/firefox
```
