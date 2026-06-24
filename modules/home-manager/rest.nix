{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.rest;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.rest.enable = lib.mkEnableOption "rest";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      jq
    ];
    programs.nixvim = {
      opts.splitright = true;
      plugins.rest.enable = true;
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ http ];
      autoCmd = [
        {
          event = "FileType";
          pattern = "http";
          callback.__raw = ''
            function()
              vim.keymap.set("n", "<CR>", "<Cmd>Rest run<CR>", { buffer = true, desc = "Run REST request" })
            end
          '';
        }
        {
          event = "FileType";
          pattern = "http";
          callback.__raw = ''
            function()
              vim.keymap.set("n", "<Leader>re", "<Cmd>Rest env select<CR>", { buffer = true, desc = "Select REST env file" })
            end
          '';
        }
        {
          event = "FileType";
          pattern = "json";
          callback.__raw = ''
            function()
              vim.bo.formatprg = "jq"
            end
          '';
        }
        {
          event = "FileType";
          pattern = "html";
          callback.__raw = ''
            function()
              vim.bo.formatprg = "prettier --parser html"
            end
          '';
        }
        {
          event = "FileType";
          pattern = "rest_nvim_result";
          callback.__raw = ''
            function()
              vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true, silent = true })
            end
          '';
        }
      ];
    };
  };
}
