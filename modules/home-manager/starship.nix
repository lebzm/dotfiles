{ config, lib, ... }:
let
  cfg = config.modules.starship;
in
{
  options.modules.starship = lib.mkEnableOption "starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
  };
}
