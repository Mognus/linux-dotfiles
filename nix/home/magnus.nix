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
  ];

  xdg.configFile."fish".source = link ".config/fish";
  xdg.configFile."nvim".source = link ".config/nvim";
  xdg.configFile."tmux".source = link ".config/tmux";
  home.file.".gitconfig".source = link ".gitconfig";
}
