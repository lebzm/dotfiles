{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.bash;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.bash.enable = lib.mkEnableOption "bash";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bash-language-server
      # shellcheck
      # shfmt
    ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ bash ];
      lsp.servers.bashls.enable = true;
    };
  };
}
