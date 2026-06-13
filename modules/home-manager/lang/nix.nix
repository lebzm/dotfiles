{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.lang.nix;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.nix.enable = lib.mkEnableOption "nix";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ nix ];
      plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
      lsp.servers.nixd = {
        enable = true;
        config.settings.nixd = {
          nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
        };
      };
    };
  };
}
