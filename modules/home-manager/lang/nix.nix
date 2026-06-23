{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.nix;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.nix.enable = lib.mkEnableOption "nix";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ nix ];
      lsp.servers.nixd = {
        enable = true;
        config.settings.nixd = {
          formatting.command = [ "nixfmt" ];
          nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
        };
      };
    };
  };
}
