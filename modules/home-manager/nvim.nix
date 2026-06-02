{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nvim;
in

{
  options.modules.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      # general
      {
        programs.nixvim = {
          enable = true;
          defaultEditor = true;
          clipboard.register = "unnamedplus";
          globals.mapleader = " ";
          keymaps = [
            {
              key = "jj";
              action = "<esc>";
              mode = [
                "i"
                "c"
              ];
            }
          ];
        };
      }

      # ui
      {
        programs.nixvim = {
          colorschemes.catppuccin.enable = true;
          plugins = {
            lualine.enable = true;
            noice.enable = true;
          };
        };
      }

      # movement
      {
        programs.nixvim = {
          plugins = {
            flash = {
              enable = true;
              settings = {
                modes.search.enabled = false;
                modes.char.enabled = false;
                prompt.enabled = false;
              };
            };
          };
          keymaps = [
            {
              key = ";";
              action.__raw = ''function() require("flash").jump() end'';
              mode = [
                "n"
                "o"
                "x"
              ];
            }
          ];
        };
      }

      # editor
      {
        programs.nixvim = {
          plugins = {
            fzf-lua.enable = true;
          };
        };
      }

      # ai
      (
        let
          pi-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "pi-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "alex35mil";
              repo = "pi.nvim";
              rev = "main";
              sha256 = "sha256-X+aW4G+jYKX1T/XPNlDMgRj0fxRQtoTzo/PuZ+z9zLI=";
            };
          };
        in
        {
          home.packages = with pkgs.llm-agents; [ pi ];
          programs.nixvim = {
            extraPlugins = [ pi-nvim ];
          };
        }
      )

    ]
  );
}
