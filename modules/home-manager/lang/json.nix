{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.lang.json;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.json.enable = lib.mkEnableOption "json";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ json ];
      plugins.conform-nvim.settings.formatters_by_ft.json = [ "oxfmt" ];
    };
  };
}
