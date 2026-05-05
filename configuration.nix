{
  lib,
  pkgs,
  inputs,
  platform,
  ...
}:

with lib;

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./users
  ];

  nixpkgs = {
    overlays = [
      inputs.brew-nix.overlays.default
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    gnumake
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    {
      imports = [
        ./modules/emacs
      ];
      xdg.enable = true;
      home.stateVersion = "26.05";
    }
  ];

  system.stateVersion = 6;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
    keep-outputs = true
    keep-derivations = true
    accept-flake-config = true
    trusted-users = root bzm
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

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
    iosevka
  ];

  system.activationScripts.postActivation.text = ''
    # Apply changes without logout/login cycle.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

}
