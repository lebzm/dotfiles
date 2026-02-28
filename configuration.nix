{
  config,
  lib,
  pkgs,
  username,
  platform,
  inputs,
  ...
}:

with lib;

{
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ({
      options.mod.activationScripts = mkOption {
        type = types.attrsOf (
          types.submodule {
            options.text = mkOption {
              type = types.lines;
              description = "Shell script content to run during activation.";
            };
          }
        );
        default = { };
      };

      config.system.activationScripts.postActivation.text = ''
        # Apply changes without logout/login cycle.
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

        echo "running user activation scripts as ${username}..."
        sudo -u ${username} --login bash <<'EOF'
          set -euo pipefail
          ${concatStringsSep "\n\n" (
            mapAttrsToList (
              name: script: "# --- ${name} ---\n${script.text}\n# --- end ${name} ---"
            ) config.mod.activationScripts
          )}
        EOF
      '';
    })
    ./modules/emacs.nix
  ];

  environment.systemPackages = with pkgs; [
    inputs.ctools.packages."${platform}".shadowify
    inputs.zen-browser.packages."${platform}".twilight
    git
    gnumake
    pkgs.potrace
    pkgs.imagemagick
    pkgs.backgroundremover
  ];

  homebrew.enable = true;
  homebrew.casks = [
    "whatsapp"
    "discord"
    "godot"
    "slack"
    "chatgpt"
    "dbeaver-community"
    "mongodb-compass"
    "postman"
    "figma"
    "blender"
    "audacity"
    "inkscape"
    "affinity"
    "docker-desktop"
    "obs"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    {
      home.stateVersion = "26.05";
    }
  ];

  system.stateVersion = 6;
  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
    keep-outputs = true
    keep-derivations = true
  '';

  nix.package = pkgs.lixPackageSets.stable.lix;
  nixpkgs.hostPlatform = platform;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = true;
      AppleSpacesSwitchOnActivate = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
    };
    dock = {
      autohide = true;
      mru-spaces = false;
    };
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  services.aerospace = {
    enable = true;
    settings = {
      config-version = 2;
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
  mod.emacs.enable = true;
}
