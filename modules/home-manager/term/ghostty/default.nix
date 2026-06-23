{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.term.ghostty;
in

{
  options.modules.term.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf cfg.enable {
    xdg.configFile."ghostty/shaders/cursor_smear.glsl".source = ./shaders/cursor_smear.glsl;
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        macos-titlebar-style = "hidden";
        window-padding-color = "extend";
        window-padding-balance = true;
        window-padding-x = 5;
        window-padding-y = 5;
        background-opacity = 0.95;
        unfocused-split-opacity = 1;
        theme = "Catppuccin Mocha";
        custom-shader = "shaders/cursor_smear.glsl";
      };
    };
  };
}
