{
  description = "NixOS configuration for my machines";

  inputs = {
    # Same release the laptop was installed with.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations.luxxer23-laptop = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/luxxer23-laptop/configuration.nix ];
      };
    };
}
