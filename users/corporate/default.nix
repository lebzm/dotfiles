{ ... }:

{
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

  programs.zen-browser = {
    # https://github.com/0xc000022070/zen-browser-flake
    enable = true;
    policies = {
      # More policies can be browse at:
      # https://mozilla.github.io/policy-templates/
      NoDefaultBookmarks = true;
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };

    # TODO: the profiles is not working
    # profiles.default = {
    #   settings = {
    #     "zen.welcome-screen.seen" = true;
    #   };
    #   search = {
    #     force = true;
    #     default = "google";
    #   };
    # };
  };
}
