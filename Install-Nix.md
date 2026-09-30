# Install NixOS

How to put one of the machines from `nix/` onto a fresh disk. The flake describes
the partitions, the system and the home directory; the steps below cover what it
cannot: secrets, the Wi-Fi password and the clone of this repository.

Hosts: `luxxer23-laptop`, `luxxer23-desktop`.

> **Everything before Hyprland uses the US layout** — the LUKS prompt, the console
> and the login screen. Pick the disk passphrase with that in mind.

## 1. Boot the installer

Write the graphical ISO from <https://nixos.org/download> to a USB stick:

```sh
sha256sum -c latest-nixos-graphical-x86_64-linux.iso.sha256
sudo dd if=latest-nixos-graphical-x86_64-linux.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

`/dev/sdX` is the whole stick, not a partition. Check the name with `lsblk` first.

Disable Secure Boot in the firmware, open the boot menu (ASUS: hold **Esc**) and
pick the `UEFI: USB` entry, then the GNOME live session. Close the graphical
installer and connect to Wi-Fi from the top-right menu.

### Optional: work from another machine

In the live session:

```sh
passwd                      # password for the live user "nixos"
sudo systemctl start sshd
ip -br a
```

From the other machine:

```sh
ssh-keygen -R <ip>          # the address may still carry an old host key
ssh-copy-id nixos@<ip>
ssh nixos@<ip>
```

## 2. Partition and install

Check that the target disk matches `disk.main.device` in the host's `disko.nix`:

```sh
lsblk
```

Partition, encrypt and mount it under `/mnt`. **This erases the disk** and asks
for the LUKS passphrase twice:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake 'github:Mognus/linux-dotfiles?dir=nix#<host>'
```

Install the system. It asks for a root password at the end; add
`--no-root-passwd` to keep root locked and rely on `sudo`:

```sh
sudo nixos-install --flake 'github:Mognus/linux-dotfiles?dir=nix#<host>'
sudo nixos-enter --root /mnt -c 'passwd magnus'
sudo reboot
```

Pull the stick when the screen goes dark.

### First install of a host

A host installed for the first time has no `hardware-configuration.nix` yet: it
lists the kernel modules needed to reach the disk and keyboard at boot, and only
the machine itself can detect them. Generate it in a local clone and install
from there instead of from GitHub:

```sh
git clone https://github.com/Mognus/linux-dotfiles.git && cd linux-dotfiles/nix
# Disks come from disko.nix, so leave file systems out.
nixos-generate-config --no-filesystems --show-hardware-config \
  > hosts/<host>/hardware-configuration.nix
git add hosts/<host>/hardware-configuration.nix   # flakes only see tracked files

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake '.#<host>'
sudo nixos-install --flake '.#<host>'
sudo nixos-enter --root /mnt -c 'passwd magnus'
# The live system's clone is gone after the reboot; keep the file on the new disk.
sudo cp hosts/<host>/hardware-configuration.nix /mnt/etc/nixos/
sudo reboot
```

After the first login, copy `/etc/nixos/hardware-configuration.nix` into
`~/dotfiles/nix/hosts/<host>/` and commit it.

## 3. First login

Home Manager links `~/.config/*` into `~/dotfiles`, which does not exist yet.
Logging in on the greeter would start Hyprland without a config and drop straight
back to the login screen. Switch to a console first with **Ctrl+Alt+F2**, log in
as `magnus`, then:

```sh
nmtui                       # Wi-Fi, the live session's connection is gone
git clone https://github.com/Mognus/linux-dotfiles.git ~/dotfiles
```

**Ctrl+Alt+F1** returns to the greeter; logging in now starts Hyprland.

To push from this machine with the other machine's key instead of storing one
here, connect with `ssh -A` and switch the clone to SSH:

```sh
git -C ~/dotfiles remote set-url origin git@github.com:Mognus/linux-dotfiles.git
```

## 4. By hand

These stay outside the repository on purpose:

```sh
netbird up                  # asks for the login or a setup key
```

Copy the GPG key, `~/.password-store` and SSH keys only where they are needed.

## Everyday use

```sh
cd ~/dotfiles && git pull
sudo nixos-rebuild switch --flake ~/dotfiles/nix     # apply the config
nix flake update --flake ~/dotfiles/nix               # newer packages; commit flake.lock
```

Configs under `~/.config` link straight into the repository, so editing them
needs no rebuild. A broken switch is undone by picking the previous generation in
the boot menu.
