{
  config,
  pkgs,
  lib,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  # Link straight into the repo so edits apply without a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  imports = [ ./packages.nix ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # zsh: FZF key bindings
    fzf
    ripgrep
    fd
    # nvim: nvim-treesitter compiles its parsers locally
    tree-sitter
    gcc
    # opencode.nvim: discover the local OpenCode server's listening port
    lsof
    tmux
    # hyprland: terminal bound in hypr/lua/programs.lua
    alacritty
    # Hyprland launcher: native Wayland application and window search
    rofi
    adwaita-icon-theme
    # dark/light shell functions: native GTK appearance preferences
    glib
    # JSON command-line utilities
    jq
    # Clipboard, screenshots, manual recording and media keys
    wl-clipboard
    cliphist
    grim
    slurp
    swappy
    wf-recorder
    playerctl
    # hyprland autostart: bottom bar, tux mascots, wallpaper and authentication prompts
    quickshell
    awww
    polkit_gnome
    # audio and brightness keys: pactl in the autostart, mixer, laptop backlight
    pulseaudio
    pavucontrol
    brightnessctl
  ];

  home.file.".zshenv".source = link ".config/zsh/.zshenv";
  xdg.configFile."zsh".source = link ".config/zsh";
  xdg.dataFile."zsh/plugins/autosuggestions.zsh".source =
    "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
  xdg.dataFile."zsh/plugins/syntax-highlighting.zsh".source =
    "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
  xdg.configFile."nvim".source = link ".config/nvim";
  xdg.configFile."tmux".source = link ".config/tmux";
  xdg.configFile."hypr".source = link ".config/hypr";
  xdg.configFile."xkb".source = link ".config/xkb";
  xdg.configFile."alacritty".source = link ".config/alacritty";
  # gsettings searches this standard XDG location, not Nix's package-specific one.
  xdg.dataFile."glib-2.0/schemas".source =
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  xdg.configFile."btop/btop.conf".source = link ".config/btop/btop.conf";
  xdg.configFile."quickshell".source = link ".config/quickshell";
  home.file."Pictures/wallpapers".source = link "wallpapers";
  xdg.configFile."gtk-3.0".source = link ".config/gtk-3.0";
  xdg.configFile."gtk-4.0".source = link ".config/gtk-4.0";
  # Only the file: Home Manager keeps its own conf.d next to it.
  xdg.configFile."fontconfig/fonts.conf".source = link ".config/fontconfig/fonts.conf";
  home.file.".icons".source = link ".icons";
  xdg.configFile."mimeapps.list".source = link ".config/mimeapps.list";
  xdg.configFile."ruff".source = link ".config/ruff";
  xdg.configFile."zed".source = link ".config/zed";
  xdg.configFile."opencode/tui.json".source = link ".config/opencode/tui.json";
  # Stable autostart path; Home Manager tracks the installed agent across updates.
  home.file.".local/bin/polkit-agent".source =
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

  # A named profile gives user.js a fixed path.
  programs.firefox = {
    enable = true;
    profiles.default.isDefault = true;
  };
  home.file."${config.programs.firefox.configPath}/default/user.js".source =
    link ".config/firefox/user.js";
  # Manage only these files, not the profile's browser data. A shared
  # profiles.ini gives both machines the stable profile directory "default".
  xdg.configFile."librewolf/librewolf/profiles.ini".source =
    link ".config/librewolf/librewolf/profiles.ini";
  xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source =
    link ".config/librewolf/librewolf/librewolf.overrides.cfg";
  xdg.configFile."librewolf/librewolf/default/chrome/userChrome.css".source =
    link ".config/librewolf/librewolf/chrome/userChrome.css";

  # Both agents share one instruction file; their folders also hold local state.
  home.file.".claude/CLAUDE.md".source = link "AGENTS.md";
  home.file.".codex/AGENTS.md".source = link "AGENTS.md";
  # Claude Code saves via a temp file next to the first link hop, so this link
  # must skip the read-only store. Back to home.file once
  # https://github.com/anthropics/claude-code/issues/78162 is fixed.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ln -sfn ${dotfiles}/.claude/settings.json $HOME/.claude/settings.json
  '';

  # GTK apps read the cursor from dconf.
  # The fonts name no font: "Sans"/"Monospace" resolve through fontconfig/fonts.conf.
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "Adwaita-dark";
    color-scheme = "prefer-dark";
    cursor-theme = "macOS";
    cursor-size = 40;
    font-name = "Sans 11";
    monospace-font-name = "Monospace 11";
  };
  home.file.".gitconfig".source = link ".gitconfig";
}
