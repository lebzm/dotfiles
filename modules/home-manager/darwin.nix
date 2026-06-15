{ config, lib, ... }:

let
  cfg = config.modules.darwin;
in

{
  options.modules.darwin = {
    defaults = lib.mkEnableOption "macOS user defaults (dock, scroll direction, etc.)";
  };

  config = lib.mkIf cfg.defaults {
    targets.darwin.defaults = {
      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
      };
      "com.apple.dock" = {
        autohide = true;
      };
    };
  };
}
