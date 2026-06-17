{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.podman;
in
{
  options.modules.podman.enable = lib.mkEnableOption "podman";

  config = lib.mkIf cfg.enable {
    services.podman = {
      enable = true;
      useDefaultMachine = true;
    };
    home.packages = [ pkgs.podman-compose ];
    programs.zsh.shellAliases.docker = "podman";
    programs.nushell.shellAliases.docker = "podman";
  };
}
