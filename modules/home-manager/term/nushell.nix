{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.term.nushell;
in

{
  options.modules.term.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        keybindings = [
          {
            name = "tab_completion";
            modifier = "none";
            keycode = "tab";
            mode = [
              "emacs"
              "vi_insert"
              "vi_normal"
            ];
            event = {
              until = [
                {
                  send = "menu";
                  name = "completion_menu";
                }
                { send = "enter"; }
              ];
            };
          }
        ];
      };
    };

    programs.tmux.extraConfig = ''
      set -g default-command ${pkgs.nushell}/bin/nu
    '';
  };
}
