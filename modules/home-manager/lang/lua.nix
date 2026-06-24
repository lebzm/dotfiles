{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lang.lua;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.lang.lua.enable = lib.mkEnableOption "lua";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      luajit
      lua-language-server
      stylua
    ];
    programs.nixvim = {
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ lua ];
      lsp.servers.lua_ls = {
        enable = true;
        config = {
          on_init.__raw = ''
            function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if path ~= vim.fn.stdpath('config') then
                  return
                end
              end
              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                workspace = {
                  library = {
                    "lua",
                    vim.env.VIMRUNTIME,
                  },
                },
              })
            end
          '';
          settings = {
            Lua = {
              runtime.version = "LuaJIT";
              workspace.checkThirdParty = false;
            };
          };
        };
      };
    };
  };
}
