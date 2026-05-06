{
  pkgs,
  inputs,
  platform,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    git
    gnumake
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
    iosevka
    geist-mono
  ];

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
      keep-outputs = true
      keep-derivations = true
      accept-flake-config = true
      trusted-users = root bzm
    '';
  };

  nixpkgs = {
    overlays = [ inputs.brew-nix.overlays.default ];
    hostPlatform = platform;
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

  system.stateVersion = 6;
}
