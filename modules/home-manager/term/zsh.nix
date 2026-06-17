{ config, lib, ... }:

let
  cfg = config.modules.term.zsh;
in

{
  options.modules.term.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
