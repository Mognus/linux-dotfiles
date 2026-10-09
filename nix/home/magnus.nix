{ config, pkgs, lib, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  # Link straight into the repo, like Stow did, so edits apply without a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./packages.nix ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # fish: frg, fco, fkill and the fzf key bindings
    fzf
    ripgrep
    fd
    bat
    # nvim: nvim-treesitter compiles its parsers locally
    tree-sitter
    gcc
    tmux
    # hyprland: terminal and launcher bound in hypr/lua/programs.lua
    alacritty
    rofi
    adwaita-icon-theme
    # theme-switcher.sh reads the palettes with jq
    jq
    # hyprland binds and scripts: clipboard, screenshots, recording, media keys
    wl-clipboard
    cliphist
    grim
    slurp
    swappy
    wf-recorder
    libnotify
    playerctl
    # hyprland autostart: bar, notifications, wallpaper, idle, auth prompts
    quickshell
    dunst
    awww
    hypridle
    polkit_gnome
    # audio and brightness keys: pactl in the autostart, mixer, laptop backlight
    pulseaudio
    pavucontrol
    brightnessctl
  ];

  xdg.configFile."fish".source = link ".config/fish";
  xdg.configFile."nvim".source = link ".config/nvim";
  xdg.configFile."tmux".source = link ".config/tmux";
  xdg.configFile."hypr".source = link ".config/hypr";
  xdg.configFile."xkb".source = link ".config/xkb";
  xdg.configFile."alacritty".source = link ".config/alacritty";
  xdg.configFile."rofi".source = link ".config/rofi";
  xdg.configFile."quickshell".source = link ".config/quickshell";
  xdg.configFile."dunst".source = link ".config/dunst";
  xdg.configFile."wallpapers".source = link ".config/wallpapers";
  xdg.configFile."gtk-3.0".source = link ".config/gtk-3.0";
  xdg.configFile."gtk-4.0".source = link ".config/gtk-4.0";
  # Only the file: Home Manager keeps its own conf.d next to it.
  xdg.configFile."fontconfig/fonts.conf".source = link ".config/fontconfig/fonts.conf";
  home.file.".icons".source = link ".icons";
  xdg.configFile."mimeapps.list".source = link ".config/mimeapps.list";
  # Single file: other apps add their own launchers to this folder.
  xdg.dataFile."applications/glow.desktop".source = link ".local/share/applications/glow.desktop";
  xdg.configFile."glow".source = link ".config/glow";
  xdg.configFile."yt-dlp".source = link ".config/yt-dlp";
  xdg.configFile."ruff".source = link ".config/ruff";
  xdg.configFile."zed".source = link ".config/zed";

  # A named profile gives user.js a fixed path; install.sh had to look it up.
  programs.firefox = {
    enable = true;
    profiles.default.isDefault = true;
  };
  home.file."${config.programs.firefox.configPath}/default/user.js".source =
    link ".config/firefox/user.js";
  # Only the file: LibreWolf keeps its profiles in the same folder.
  xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source =
    link ".config/librewolf/librewolf/librewolf.overrides.cfg";

  # Both agents share one instruction file; their folders also hold local state.
  home.file.".claude/CLAUDE.md".source = link "AGENTS.md";
  home.file.".codex/AGENTS.md".source = link "AGENTS.md";
  # Claude Code saves via a temp file next to the first link hop, so this link
  # must skip the read-only store. Back to home.file once
  # https://github.com/anthropics/claude-code/issues/78162 is fixed.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ln -sfn ${dotfiles}/.claude/settings.json $HOME/.claude/settings.json
  '';

  # grim does not create the folder the Hyprland screenshot binds write to.
  # Screenshots are throwaway: anything untouched for a week gets deleted.
  systemd.user.tmpfiles.rules = [ "d %h/Pictures/screenshots - - - 7d" ];

  # GTK apps read the cursor from dconf; install.sh set this through gsettings.
  # The fonts name no font: "Sans"/"Monospace" resolve through fontconfig/fonts.conf.
  dconf.settings."org/gnome/desktop/interface" = {
    cursor-theme = "macOS";
    cursor-size = 40;
    font-name = "Sans 11";
    monospace-font-name = "Monospace 11";
  };
  home.file.".gitconfig".source = link ".gitconfig";
}
