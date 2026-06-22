{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.lang.yaml;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.yaml.enable = lib.mkEnableOption "yaml";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ yaml ];
      plugins.conform-nvim.settings.formatters_by_ft.yaml = [ "oxfmt" ];
    };
  };
}
