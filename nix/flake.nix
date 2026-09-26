{
  description = "NixOS configuration for my machines";

  inputs = {
    # Rolling like Arch, so Hyprland and Quickshell match the desktop's versions.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      # The main branch tracks nixos-unstable.
      url = "github:nix-community/home-manager";
      # Build Home Manager against our nixpkgs instead of its own copy.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.luxxer23-laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/luxxer23-laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.magnus = import ./home/magnus.nix;
          }
        ];
      };
    };
}
