{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ghostty;
in

{
  options.modules.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf cfg.enable {
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
    home.file.".config/ghostty/shaders/cursor_smear.glsl".source = ./ghostty/shaders/cursor_smear.glsl;
  };
}
