{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.mise;
in

{
  options.modules.mise.enable = lib.mkEnableOption "mise";

  config = lib.mkIf cfg.enable {
    programs.mise = {
      enable = true;
      globalConfig = {
        settings = {
          trusted_config_paths = [
            "~/pinggirjurang.studio"
            "~/amartha"
          ];
        };
      };
    };
  };
}
