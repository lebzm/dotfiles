{
  description = "bzm nix-darwin configurations";

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

        billyzaelanimalik_amartha = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            username = "billyzaelanimalik";
            platform = "aarch64-darwin";
          };
          modules = [
            ./users/billyzaelanimalik
            ./configuration.nix
          ];
        };

        bzm_amartha = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            username = "bzm";
            platform = "aarch64-darwin";
          };
          modules = [
            ./users/bzm
            ./configuration.nix
          ];
        };

        bzm_quicksilver = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            username = "bzm";
            platform = "aarch64-darwin";
          };
          modules = [
            ./users/bzm
            ./configuration.nix
          ];
        };

      };
    };
}
