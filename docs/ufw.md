# UFW Firewall

Default policy for a desktop workstation:
- **Incoming: deny** — nothing reaches you from outside
- **Outgoing: allow** — you can connect anywhere

## Setup

```bash
sudo pacman -S ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw
```

## Status

```bash
sudo ufw status verbose
```

## Allow exceptions (if needed)

```bash
sudo ufw allow ssh          # SSH from anywhere
sudo ufw allow from 192.168.1.0/24 to any port 22  # SSH from LAN only
sudo ufw deny 8080          # explicitly block a port
```

## Disable

```bash
sudo ufw disable
sudo systemctl disable ufw
```
