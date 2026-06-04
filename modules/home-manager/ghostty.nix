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
        custom-shader = "shaders/cursor_smear.glsl";
      };
    };
    home.file.".config/ghostty/shaders/cursor_smear.glsl".source = ./shaders/cursor_smear.glsl;
  };
}
