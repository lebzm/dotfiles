{ config, pkgs, ... }:

{
  imports = [ ../home-manager.nix ];

  home.username = "billyzaelanimalik";
  home.homeDirectory = "/Users/billyzaelanimalik";

  modules = {
    zed.enable = true;
    ghostty.enable = true;
    nvim = {
      enable = true;
      dotfilesPath = config.home.homeDirectory;
    };
  };

  home.packages = with pkgs.brewCasks; [
    mongodb-compass
    # openvpn-connect # broken
    slack
    # whatsapp # broken
    zen
  ];

  programs.zsh.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "bitbucket.org" = {
        user = "git";
        hostname = "bitbucket.org";
        identityFile = "~/.ssh/amartha";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = "~/.ssh/personal";
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
      url."ssh://git@bitbucket.org/".insteadOf = "https://bitbucket.org/";
      user = {
        email = "billy.malik@amartha.com";
        name = "Billy Zaelani Malik";
      };
    };
  };
}
