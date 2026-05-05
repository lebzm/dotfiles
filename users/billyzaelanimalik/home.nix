{ pkgs, ... }:

{
  home.packages = with pkgs.brewCasks; [
    chatgpt
    dbeaver-community
    discord
    docker-desktop
    mongodb-compass
    # openvpn-connect # broken
    postman
    slack
    # whatsapp # broken
    zen
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
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
