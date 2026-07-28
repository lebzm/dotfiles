{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.claudecode;
in

{
  options.modules.claudecode.enable = lib.mkEnableOption "claudecode";

  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      # TODO: more setup
    };

    programs.nixvim = {
      plugins.claudecode = {
        enable = true;
      };
      # TODO: more setup
    };
  };
}
