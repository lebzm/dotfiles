{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.go;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.go.enable = lib.mkEnableOption "go";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ go ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ go ];
      plugins.conform-nvim.settings.formatters_by_ft.go = [ "gofumpt" ];
      plugins.neotest.adapters.golang = {
        enable = true;
        settings.go_test_args = {
          __raw = ''
            function()
              return { "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out" }
            end
          '';
        };
      };
      autoCmd = [
        {
          event = "FileType";
          pattern = "go";
          callback.__raw = ''function() require("coverage").load(true) end '';
        }
      ];
      lsp.servers.gopls.enable = true;
    };
  };
}
