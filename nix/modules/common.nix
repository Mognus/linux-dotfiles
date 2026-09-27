# System configuration shared by every machine.
{ pkgs, ... }:
{
  # Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # US keys for the LUKS prompt, the console and the greeter;
  # Hyprland switches to the custom layout from the dotfiles.
  console.keyMap = "us";
  services.xserver.xkb.layout = "us";

  users.users."magnus" = {
    isNormalUser = true;
    description = "Magnus";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Login: a text greeter that remembers the user and starts Hyprland.
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    perf
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    noto-fonts-cjk-sans
    # Syne (Quickshell) has no package of its own; google-fonts would pull ~1 GB for it.
    (runCommand "syne-font" { } ''
      install -Dm644 ${../fonts}/*.ttf -t $out/share/fonts/truetype
    '')
  ];

  programs.fish.enable = true;
  programs.hyprland.enable = true;
  # Registers the PAM service hyprlock needs to unlock the session.
  programs.hyprlock.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.steam.enable = true;
  programs.thunar.enable = true;

  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  # Runs prebuilt binaries (Claude Code, Codex) that expect a regular Linux loader.
  programs.nix-ld.enable = true;

  # Audio through PipeWire, with ALSA and PulseAudio clients supported.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Thunar: mounts, trash and remote locations, plus thumbnails.
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Rootless containers; the user socket lets compose tools reach Podman.
  virtualisation.podman.enable = true;
  systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

  # VPN configurations
  services.netbird.enable = true;
}
