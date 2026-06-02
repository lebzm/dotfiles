{
  config,
  lib,
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
              action = "<Esc>";
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

    ]
  );
}
