{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.term.qol;
in
{
  options.modules.term.qol.enable = lib.mkEnableOption "qol";

  config = lib.mkIf cfg.enable {
    # Better shell prompt compatible for all shell.
    programs.starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };

    # Better shell completion compatible for all shell.
    programs.carapace.enable = true;

    # Better shell environment per project.
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
