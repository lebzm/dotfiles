{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.tmux;
in

{
  options.modules.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      prefix = "C-Space";
      disableConfirmationPrompt = true;
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
      ];
    };
  };
}
