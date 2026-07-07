{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.aerospace;
in
{
  options.modules.aerospace.enable = lib.mkEnableOption "aerospace";

  config = lib.mkIf cfg.enable {
    launchd.agents.aerospace = lib.mkForce {
      enable = true;
      config = {
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/bin/wait4path /nix/store && exec ${config.programs.aerospace.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        # NOTE: https://github.com/nix-community/home-manager/issues/9611
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/aerospace.out.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/aerospace.err.log";
      };
    };

    programs.aerospace = {
      enable = true;
      package = pkgs.aerospace;
      launchd = {
        enable = false;
        keepAlive = true;
      };
      settings = {
        config-version = 2;
        start-at-login = false;
        automatically-unhide-macos-hidden-apps = true;

        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 0;
          outer.right = 8;
        };

        persistent-workspaces = [
          "main"
          "browser"
          "ai"
          "code"
          "vm"
        ];

        on-window-detected = [
          {
            "if".app-id = "com.hnc.Discord";
            run = [ "move-node-to-workspace main" ];
          }
          {
            "if".app-id = "com.tinyspeck.slackmacgap";
            run = [ "move-node-to-workspace main" ];
          }
          {
            "if".app-id = "com.apple.Safari";
            run = [ "move-node-to-workspace browser" ];
          }
          {
            "if".app-id = "app.zen-browser.zen";
            run = [ "move-node-to-workspace browser" ];
          }
          {
            "if".app-id = "com.openai.chat";
            run = [ "move-node-to-workspace ai" ];
          }
          {
            "if".app-id = "com.mitchellh.ghostty";
            run = [ "move-node-to-workspace code" ];
          }
          {
            "if".app-id = "com.vmware.fusion";
            run = [ "move-node-to-workspace vm" ];
          }
          {
            "if".app-id = "com.apple.finder";
            run = [ "layout floating" ];
          }
          {
            "if".app-id = "net.whatsapp.WhatsApp";
            run = [ "layout floating" ];
          }
        ];

        mode.main.binding = {
          cmd-ctrl-f = "fullscreen";

          cmd-1 = "workspace main";
          cmd-2 = "workspace browser";
          cmd-3 = "workspace ai";
          cmd-4 = "workspace code";
          cmd-5 = "workspace vm";

          cmd-ctrl-1 = "move-node-to-workspace main";
          cmd-ctrl-2 = "move-node-to-workspace browser";
          cmd-ctrl-3 = "move-node-to-workspace ai";
          cmd-ctrl-4 = "move-node-to-workspace code";
          cmd-ctrl-5 = "move-node-to-workspace vm";
        };
      };
    };
  };
}
