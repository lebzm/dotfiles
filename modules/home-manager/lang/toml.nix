{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.lang.toml;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.toml.enable = lib.mkEnableOption "toml";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ toml ];
      plugins.conform-nvim.settings.formatters_by_ft.toml = [ "oxfmt" ];
    };
  };
}
