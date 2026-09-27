# ASUS Vivobook: everything that only applies to this machine.
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "luxxer23-laptop";

  # Reached from the desktop over SSH.
  services.openssh.enable = true;

  services.power-profiles-daemon.enable = true;

  # First NixOS release on this machine. Never change it, see
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
