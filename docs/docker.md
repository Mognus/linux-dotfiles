# Docker Setup on Arch Linux

## Installation

Use legacy `iptables` — `iptables-nft` causes nftables ruleset conflicts that break container networking.

```bash
sudo pacman -S docker iptables
```

If `iptables-nft` is already installed, pacman will ask to replace it — confirm.

## Start & enable

```bash
sudo systemctl enable --now docker
sudo systemctl disable nftables
```

> Disabling `nftables` prevents its ruleset from blocking Docker's forwarded traffic on boot.

## Add user to docker group

```bash
sudo usermod -aG docker $USER
newgrp docker
```

> `newgrp docker` activates the group in the current shell without requiring a re-login.

## If container networking still doesn't work

Flush leftover nftables rules from the running kernel:

```bash
sudo nft flush ruleset
```

## Verify

```bash
docker run --rm alpine ping -c 2 8.8.8.8
```
