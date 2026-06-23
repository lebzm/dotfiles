{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.zig;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.zig.enable = lib.mkEnableOption "zig";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zig
      zls
    ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ zig ];
      lsp.servers.zls.enable = true;
    };
  };
}
