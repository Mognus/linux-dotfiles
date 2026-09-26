{
  description = "NixOS configuration for my machines";

  inputs = {
    # Same release the laptop was installed with.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
