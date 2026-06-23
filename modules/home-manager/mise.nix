{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.mise;
in

{
  options.modules.mise = {
    enable = lib.mkEnableOption "mise";
    trustedConfigPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of trusted config paths for mise.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mise = {
      enable = true;
      globalConfig = {
        settings = {
          trusted_config_paths = cfg.trustedConfigPaths ++ [ "~/.config/dotfiles" ];
        };
      };
    };
  };
}
