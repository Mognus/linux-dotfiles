# Desktop tower: everything that only applies to this machine.
# Windows lives on the second disk and is started from the firmware boot menu.
{ ... }:
{
  imports = [
    # Generated during installation, see Install-Nix.md.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "luxxer23-desktop";

  # First NixOS release on this machine. Never change it, see
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11";
}
