{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nushell;
in

{
  options.modules.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
      };
    };

    programs.tmux.extraConfig = ''
      set -g default-command ${pkgs.nushell}/bin/nu
    '';
  };
}
