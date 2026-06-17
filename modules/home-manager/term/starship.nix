{ config, lib, ... }:
let
  cfg = config.modules.term.starship;
in
{
  options.modules.term.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
  };
}
