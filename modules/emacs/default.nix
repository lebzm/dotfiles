{
  lib,
  pkgs,
  ...
}:

let
  generated = import ./generated.nix { inherit pkgs; };
  inherit (pkgs) emacs;
in

{
  programs.emacs = {
    enable = true;
    package = emacs;
    extraPackages = generated.epkgs;
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  home.packages = generated.pkgs;
  home.activation.tangleEmacsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run \
      ${emacs}/bin/emacs ${./.}/emacs.org \
      -Q --batch \
      --eval '(org-babel-tangle nil nil "^elisp$")' \
      --kill
  '';
}
