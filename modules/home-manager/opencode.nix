{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.opencode;
in

{
  options.modules.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      tui.theme = "system";
      settings = {
        model = "opencode-go/kimi-k2.6";
        default_agent = "plan";
        autoupdate = false;
      };
      agents = { };
      commands = { };
      skills = { };
      tools = { };
      # TODO: setup mcp
    };

    programs.nixvim = {
      plugins.opencode.enable = true;
      keymaps = [
        {
          key = "<Leader><Tab>";
          action.__raw = ''function() require("opencode").command("agent.cycle") end'';
          mode = [ "n" ];
        }
        {
          key = "<Leader>/";
          action.__raw = ''function() require("opencode").select() end'';
          mode = [ "n" ];
        }
        {
          key = "<Leader>a";
          action.__raw = ''function() require("opencode").ask() end'';
          mode = [ "n" ];
        }
        {
          key = "<Leader>a";
          action.__raw = ''function() require("opencode").ask("@this: ") end'';
          mode = [ "x" ];
        }
      ];
    };
  };
}
