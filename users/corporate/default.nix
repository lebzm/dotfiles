{ pkgs, ... }:

{
  home.packages = with pkgs.brewCasks; [
    chatgpt
    dbeaver-community
    discord
    docker-desktop
    mongodb-compass
    openvpn-connect
    postman
    slack
    whatsapp
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
