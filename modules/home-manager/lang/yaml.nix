{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.yaml;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.yaml.enable = lib.mkEnableOption "yaml";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ yaml-language-server ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ yaml ];
      lsp.servers.yamlls = {
        enable = true;
        config.settings.redhat.telemetry.enabled = false;
        config.settings.yaml = {
          format.enable = true;
          validate = true;
        };
      };
    };
  };
}
