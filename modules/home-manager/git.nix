{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.git;
in

{
  options.modules.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.codediff.enable = true;
      plugins.gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
        };
      };
      plugins.neogit = {
        enable = true;
        settings = {
          kind = "floating";
          commit_editor.kind = "floating";
          commit_editor.spell_check = false;
          disable_hint = true;
        };
      };
      keymaps = [
        {
          key = "<Leader>g";
          action.__raw = ''function() require("neogit").open() end'';
          mode = [ "n" ];
        }
      ];
    };
  };
}
