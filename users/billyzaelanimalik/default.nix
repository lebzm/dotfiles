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
