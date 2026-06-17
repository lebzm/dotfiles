{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.term.direnv;
in
{
  options.modules.term.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
