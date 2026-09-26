{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  # Link straight into the repo, like Stow did, so edits apply without a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
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
  ];

  xdg.configFile."fish".source = link ".config/fish";
  xdg.configFile."nvim".source = link ".config/nvim";
  xdg.configFile."tmux".source = link ".config/tmux";
  xdg.configFile."hypr".source = link ".config/hypr";
  xdg.configFile."xkb".source = link ".config/xkb";
  xdg.configFile."alacritty".source = link ".config/alacritty";
  xdg.configFile."rofi".source = link ".config/rofi";
  home.file.".gitconfig".source = link ".gitconfig";
}
