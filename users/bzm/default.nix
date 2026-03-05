{ pkgs, ... }:

{
  home.packages = with pkgs.brewCasks; [
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
        email = "bzm@pinggirjurang.studio";
        name = "Billy Zaelani Malik";
      };
    };
  };
}
