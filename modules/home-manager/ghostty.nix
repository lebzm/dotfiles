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
        theme = "Catppuccin Mocha";
        background-opacity = 0.95;
        custom-shader = "shaders/cursor_smear.glsl";
        unfocused-split-opacity = 1;
      };
    };
    home.file.".config/ghostty/shaders/cursor_smear.glsl".source = ./shaders/cursor_smear.glsl;
  };
}
