{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  # Link straight into the repo, like Stow did, so edits apply without a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.stateVersion = "26.05";

  xdg.configFile."fish".source = link ".config/fish";
}
