{ config, lib, ... }:
let
  cfg = config.modules.term.carapace;
in
{
  options.modules.term.carapace.enable = lib.mkEnableOption "carapace";

  config = lib.mkIf cfg.enable {
    programs.carapace = {
      enable = true;
    };
  };
}
