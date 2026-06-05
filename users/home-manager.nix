{ inputs, ... }:

{
  imports = [
    ../modules/home-manager
    inputs.nixvim.homeModules.nixvim
  ];

  nixpkgs.overlays = [
    inputs.brew-nix.overlays.default
    inputs.llm-agents.overlays.default
  ];

  xdg.enable = true;
  home.stateVersion = "26.05";
}
