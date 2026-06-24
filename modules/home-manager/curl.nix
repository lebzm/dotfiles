{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.curl;
  curl-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "curl-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "oysandvik94";
      repo = "curl.nvim";
      rev = "f3c258e57d56a6158733a9e3bb5eeb931f204d19";
      hash = "sha256-CrDjESWLQGps9o/8giGHjZKTjeyaSDynaZos35Tf1io=";
    };
    doCheck = false;
  };
in

{
  options.modules.curl.enable = lib.mkEnableOption "curl";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      jq
    ];
    programs.nixvim = {
      extraPlugins = [ curl-nvim ];
      extraConfigLua = ''
        require("curl").setup({
          open_with = "vsplit",
          default_flags = { "-i" },
          mappings = {
            execute_curl = "<CR>"
          }
        })
      '';
      autoCmd = [
        {
          event = "BufEnter";
          callback.__raw = ''
            function()
              local bufname = vim.fn.bufname()
              local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
              if buftype == "nofile" and bufname:match("^Curl output_") then
                vim.keymap.set("n", "q", function() require("curl").close_curl_tab() end, { buffer = true, silent = true })
              end
            end
          '';
        }
      ];
    };
  };
}
