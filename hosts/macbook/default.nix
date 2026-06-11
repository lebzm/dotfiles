{
  imports = [ ../nix-darwin.nix ];

  services.aerospace = {
    enable = true;
    settings = {
      config-version = 2;
      automatically-unhide-macos-hidden-apps = true;

      gaps = {
        inner.horizontal = 4;
        inner.vertical = 4;
        outer.left = 4;
        outer.bottom = 4;
        outer.top = 0;
        outer.right = 4;
      };

      persistent-workspaces = [
        "main"
        "browser"
        "code"
        "ai"
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
          "if".app-id = "org.gnu.Emacs";
          run = [ "move-node-to-workspace code" ];
        }
        {
          "if".app-id = "com.openai.chat";
          run = [ "move-node-to-workspace ai" ];
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

        cmd-h = "focus left";
        cmd-j = "focus down";
        cmd-k = "focus up";
        cmd-l = "focus right";

        cmd-shift-h = "move left";
        cmd-shift-j = "move down";
        cmd-shift-k = "move up";
        cmd-shift-l = "move right";

        cmd-1 = "workspace main";
        cmd-2 = "workspace browser";
        cmd-3 = "workspace code";
        cmd-4 = "workspace ai";
        cmd-5 = "workspace vm";

        cmd-ctrl-1 = "move-node-to-workspace main";
        cmd-ctrl-2 = "move-node-to-workspace browser";
        cmd-ctrl-3 = "move-node-to-workspace code";
        cmd-ctrl-4 = "move-node-to-workspace ai";
        cmd-ctrl-5 = "move-node-to-workspace vm";
      };
    };
  };
}
