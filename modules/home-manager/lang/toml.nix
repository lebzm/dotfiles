{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.toml;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.toml.enable = lib.mkEnableOption "toml";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ taplo ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ toml ];
      lsp.servers.taplo.enable = true;
    };
  };
}
