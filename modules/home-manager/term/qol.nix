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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Better shell prompt compatible for all shell.
      {
        programs.starship = {
          enable = true;
          presets = [ "nerd-font-symbols" ];
        };
      }

      # Better shell completion compatible for all shell.
      {
        programs.carapace.enable = true;
      }

      # Better shell environment per project.
      {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      }

      # Better cd.
      {
        programs.zoxide.enable = true;
        programs.zsh.shellAliases.cd = "z";
        programs.nushell.shellAliases.cd = "z";
      }
    ]
  );
}
