{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.markdown;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.markdown.enable = lib.mkEnableOption "markdown";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ rumdl ];
    programs.nixvim = {
      plugins.render-markdown.enable = true;
      plugins.treesitter.grammarPackages = with treesitterGrammars; [
        markdown
        markdown_inline
      ];
      lsp.servers.rumdl.enable = true;
    };
  };
}
