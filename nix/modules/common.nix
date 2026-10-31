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

  # Build the manual-page search index used by apropos and whatis.
  documentation.man.cache.enable = true;

  # Fast filename searches with locate; refresh the file index automatically.
  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.zsh;
  };

  # Login: a text greeter that remembers the user and starts Hyprland through UWSM.
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland-uwsm.desktop'";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    perf
    # On-demand lab VPN connections, e.g. sudo openvpn --config htb.ovpn.
    openvpn
  ];

  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    # VGA for monospace, Alacritty and Quickshell; Plex Sans for GUI text.
    ultimate-oldschool-pc-font-pack
    (ibm-plex.override { families = [ "sans" ]; })
    # Unicode terminal glyphs and Nerd Font icons missing from the VGA font.
    dejavu_fonts
    nerd-fonts.symbols-only
  ];

  programs.zsh.enable = true;
  # Expose package completions; the dotfiles configure their own Tab menu.
  programs.zsh.enableCompletion = true;
  programs.hyprland.enable = true;
  # Activates graphical-session.target, which the portal (dark mode for
  # Firefox, screen sharing) requires before it starts.
  programs.hyprland.withUWSM = true;
  # PAM service the Quickshell lock screen (lock.qml) checks the password with.
  security.pam.services.quickshell-lock = { };
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

  # KVM/QEMU virtual machines, managed through libvirt and virt-manager.
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Rootless containers; the user socket lets compose tools reach Podman.
  virtualisation.podman.enable = true;
  systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];
  # Use explicit public DNS servers for containers.
  virtualisation.containers.containersConf.settings.containers.dns_servers = [ "9.9.9.9" "149.112.112.112" ];
  # Resolve short image names like "postgres:16" against Docker Hub, as Docker does.
  virtualisation.containers.registries.settings.unqualified-search-registries = [ "docker.io" ];

  # Keep the system DNS resolver available independently of VPN clients.
  services.resolved.enable = true;
}
