{ inputs, ... }:

{
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    {
      imports = [
        ../modules/home-manager
        inputs.nixvim.homeModules.nixvim
        inputs.lazyvim.homeManagerModules.default
      ];
      xdg.enable = true;
      home.stateVersion = "26.05";
    }
  ];
}
