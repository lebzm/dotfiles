{ lib, ... }:

{
  imports =
    let
      dir = builtins.readDir ./.;
      modules = lib.filterAttrs (
        name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
      ) dir;
    in
    lib.mapAttrsToList (name: _: ./. + "/${name}") modules;
}
