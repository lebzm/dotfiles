{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  modules = {
    zed = {
      enable = true;
      nix.enable = true;
      go.enable = true;
      gleam.enable = true;
    };
  };

  home.packages = with pkgs.brewCasks; [
    affinity
    audacity
    blender
    chatgpt
    discord
    godot
    obs
    (steam.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-X1VnDJGv02A6ihDYKhedqQdE/KmPAQZkeJHudA6oS6M=";
      };
    }))
    zen
    (google-chrome.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-U1KJ6LWPWErizOq4XHoRBMnotvXmGuFB/wSmc31pGXU=";
      };
    }))
  ];

  programs.zsh.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "git.sr.ht" = {
        user = "git";
        hostname = "git.sr.ht";
        identityFile = "~/.ssh/bzm";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = "~/.ssh/bzm";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
    ];
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "current";
      user = {
        email = "bzm@pinggirjurang.studio";
        name = "Billy Zaelani Malik";
      };
    };
  };
}
