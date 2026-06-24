{ config, pkgs, ... }:

{
  imports = [ ../home-manager.nix ];

  home.username = "bzm";
  home.homeDirectory = "/Users/bzm";

  modules = {
    darwin.defaults = true;
    aerospace.enable = true;
    nvim = {
      enable = true;
      dotfilesPath = config.home.homeDirectory;
    };
    git.enable = true;
    curl.enable = true;
    hurl.enable = true;
    rest.enable = true;
    opencode.enable = true;
    podman.enable = true;
    mise = {
      enable = true;
      trustedConfigPaths = [
        "~/lebzm"
        "~/pinggirjurang.studio"
      ];
    };
  };

  modules.term = {
    ghostty.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    nushell.enable = true;
    qol.enable = true;
  };

  modules.lang = {
    markdown.enable = true;
    json.enable = true;
    toml.enable = true;
    yaml.enable = true;
    bash.enable = true;
    nix.enable = true;
  };

  modules.lang = {
    go.enable = true;
    gleam.enable = true;
    zig.enable = true;
  };

  home.packages = with pkgs.brewCasks; [
    affinity
    audacity
    blender
    discord
    godot
    helium-browser
    obs
    (steam.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-X1VnDJGv02A6ihDYKhedqQdE/KmPAQZkeJHudA6oS6M=";
      };
    }))
    (google-chrome.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-U1KJ6LWPWErizOq4XHoRBMnotvXmGuFB/wSmc31pGXU=";
      };
    }))
    zen
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
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

  # TODO: move into modules.git
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
