{
  description = "bzm nixos and nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };
  };

  outputs =
    { nix-darwin, ... }@inputs:
    {
      darwinConfigurations = {
        amartha = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            platform = "aarch64-darwin";
            primaryUser = "bzm";
          };
          modules = [
            ./hosts/macbook
            ./users/bzm
            ./users/billyzaelanimalik
          ];
        };

        quicksilver = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            platform = "aarch64-darwin";
            primaryUser = "bzm";
          };
          modules = [
            ./hosts/macbook
            ./users/bzm
          ];
        };

      };
    };
}
