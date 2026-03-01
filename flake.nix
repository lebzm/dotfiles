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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    ctools = {
      url = "github:pinggirjurangstudio/ctools";
      inputs.nixpkgs.follows = "nixpkgs";
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
          modules = [ ./configuration.nix ];
        };

        bzm_amartha = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            username = "bzm";
            platform = "aarch64-darwin";
          };
          modules = [ ./configuration.nix ];
        };

        bzm_quicksilver = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            username = "bzm";
            platform = "aarch64-darwin";
          };
          modules = [ ./configuration.nix ];
        };

      };
    };
}
