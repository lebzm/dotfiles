{ inputs, ... }:

{
  imports = [
    ../modules/home-manager
    inputs.nixvim.homeModules.nixvim
    inputs.lazyvim.homeManagerModules.default
  ];

  nixpkgs.overlays = [
    inputs.brew-nix.overlays.default
  ];

  xdg.enable = true;
  home.stateVersion = "26.05";
}
