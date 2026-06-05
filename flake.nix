{
  description = "bzm nixos and nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:

    let
      system = "aarch64-darwin";
    in
    import ./mkflake.nix {
      inherit inputs;
      systems = [ system ];
      imports = [
        {
          darwinConfigurations = {
            amartha = nix-darwin.lib.darwinSystem {
              specialArgs = { inherit inputs system; };
              modules = [ ./hosts/macbook ];
            };

            quicksilver = nix-darwin.lib.darwinSystem {
              specialArgs = { inherit inputs system; };
              modules = [ ./hosts/macbook ];
            };
          };

          homeConfigurations = {
            bzm = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./users/bzm ];
            };

            billyzaelanimalik = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./users/billyzaelanimalik ];
            };
          };
        }

        {
          perSystem =
            { pkgs, ... }:
            {
              # See: https://treefmt.com/latest/getting-started/configure/#config-file
              treefmt = {
                formatter = {
                  nixfmt = {
                    command = "${pkgs.nixfmt}/bin/nixfmt";
                    includes = [ "*.nix" ];
                  };
                  prettier = {
                    command = "${pkgs.prettier}/bin/prettier";
                    options = [ "--write" ];
                    includes = [
                      "*.md"
                      "*.json"
                      "*.yaml"
                      "*.yml"
                    ];
                    excludes = [ ".zed/*.json" ];
                  };
                  actionlint = {
                    command = "${pkgs.actionlint}/bin/actionlint";
                    includes = [
                      ".github/workflows/*.yaml"
                      ".github/workflows/*.yml"
                    ];
                  };
                };
              };
            };
        }
      ];
    };
}
