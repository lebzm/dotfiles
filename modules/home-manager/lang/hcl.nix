{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.hcl;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.hcl.enable = lib.mkEnableOption "hcl";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opentofu
      tofu-ls
    ];
    programs.nixvim = {
      filetype.extension = {
        tf = "terraform";
        tfvars = "terraform";
      };
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ hcl ];
      lsp.servers.tofu_ls.enable = true;
    };
  };
}
