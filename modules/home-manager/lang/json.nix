{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.json;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.json.enable = lib.mkEnableOption "json";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vscode-langservers-extracted ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ json ];
      lsp.servers.jsonls = {
        enable = true;
        config.settings.json = {
          format.enable = true;
          validate.enable = true;
        };
      };
    };
  };
}
