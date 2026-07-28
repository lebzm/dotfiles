{ inputs, ... }:

{
  imports = [
    ../modules/home-manager
    inputs.nixvim.homeModules.nixvim
  ];

  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;
    overlays = [
      inputs.brew-nix.overlays.default
      inputs.llm-agents.overlays.default
    ];
  };

  xdg.enable = true;
  home.stateVersion = "26.05";
}
