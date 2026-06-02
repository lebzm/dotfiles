{ pkgs, ... }:

{
  imports = [ ../home-manager.nix ];

  home.username = "billyzaelanimalik";
  home.homeDirectory = "/Users/billyzaelanimalik";

  modules = {
    zed.enable = true;
  };

  home.packages = with pkgs.brewCasks; [
    mongodb-compass
    # openvpn-connect # broken
    slack
    # whatsapp # broken
    zen
  ];

  programs.lazyvim.enable = true;

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
