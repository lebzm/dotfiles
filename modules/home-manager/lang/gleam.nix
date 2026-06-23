{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.gleam;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.gleam.enable = lib.mkEnableOption "gleam";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gleam
      rebar3
      erlang
      bun
    ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ gleam ];
      lsp.servers.gleam.enable = true;
    };
  };
}
