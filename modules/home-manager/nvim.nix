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
          globals.leader = " ";
          keymaps = [
            {
              key = "jj";
              action = "<Esc>";
              mode = [
                "i"
                "c"
              ];
            }
            {
              key = ";";
              action = ":";
              mode = [ "n" ];
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

    ]
  );
}
