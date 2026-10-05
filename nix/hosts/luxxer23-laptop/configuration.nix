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
  users.users.magnus.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBelrBwJwiIX4N9J+JhDPutWqj2/cRXiAAc7vqcDyNU+ luxxer23-desktop"
  ];

  services.power-profiles-daemon.enable = true;

  # Battery state on D-Bus, read by the Quickshell bar (Quickshell.Services.UPower).
  services.upower.enable = true;

  # First NixOS release on this machine. Never change it, see
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
