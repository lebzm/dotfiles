{ config, pkgs, ... }:

{
  imports = [ ../home-manager.nix ];

  home.username = "billyzaelanimalik";
  home.homeDirectory = "/Users/billyzaelanimalik";

  modules = {
    darwin.defaults = true;
    aerospace.enable = true;
    nvim = {
      enable = true;
      dotfilesPath = config.home.homeDirectory;
    };
    git.enable = true;
    curl.enable = true;
    opencode.enable = true;
    podman.enable = true;
    mise = {
      enable = true;
      trustedConfigPaths = [ "~/amartha" ];
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
  };

  home.packages = with pkgs.brewCasks; [
    dbeaver-community
    mongodb-compass
    # openvpn-connect # broken
    slack
    # whatsapp # broken
    zen
  ];

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
      url."ssh://git@bitbucket.org/".insteadOf = "https://bitbucket.org/";
      user = {
        email = "billy.malik@amartha.com";
        name = "Billy Zaelani Malik";
      };
    };
  };
}
