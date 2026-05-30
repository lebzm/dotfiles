{ pkgs, ... }:

{
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

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  };

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
      user = {
        email = "billy.malik@amartha.com";
        name = "Billy Zaelani Malik";
      };
    };
  };
}
