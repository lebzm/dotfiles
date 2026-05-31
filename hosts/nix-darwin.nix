{
  pkgs,
  inputs,
  system,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    git
    gnumake
    home-manager
    ghostty-bin
    brewCasks.zen
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
    iosevka
    geist-mono
  ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings.allowed-users = [ "@admin" ];
    settings.trusted-users = [ "@admin" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
      keep-outputs = true
      keep-derivations = true
      accept-flake-config = true
    '';
  };

  nixpkgs = {
    hostPlatform = system;
    overlays = [ inputs.brew-nix.overlays.default ];
    config.allowUnfree = true;
    config.allowBroken = true;
  };

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

  system.activationScripts.postActivation.text = ''
    # Apply changes without logout/login cycle.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # TODO: remove this once nix-darwin deprecate them
  system.primaryUser = "bzm";

  system.stateVersion = 6;
}
