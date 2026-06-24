{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.hurl;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
in

{
  options.modules.hurl.enable = lib.mkEnableOption "hurl";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ hurl ];
    programs.nixvim = {
      plugins.hurl = {
        enable = true;
        settings.env_file = [ "" ];
      };
      plugins.conform-nvim.settings.formatters_by_ft.hurl = [ "hurlfmt" ];
      plugins.treesitter.grammarPackages = with treesitterGrammars; [
        hurl
        http
      ];
      extraConfigLua = ''
        package.loaded["hurl.split"] = (function()
          local Split = require("nui.split")
          local event = require("nui.utils.autocmd").event

          local split = Split({
            relative = "editor",
            position = _HURL_GLOBAL_CONFIG.split_position,
            size = _HURL_GLOBAL_CONFIG.split_size,
          })

          local utils = require("hurl.utils")

          local M = {}

          M.show = function(data, type)
            local function quit()
              vim.cmd(_HURL_GLOBAL_CONFIG.mappings.close)
              split:unmount()
            end

            split:mount()

            if _HURL_GLOBAL_CONFIG.auto_close then
              split:on(event.BufLeave, function()
                quit()
              end)
            end

            local output_lines = {}

            if type == "markdown" then
              vim.bo[split.bufnr].filetype = "text"
              output_lines = vim.split(data.body, "\n")
            else
              vim.bo[split.bufnr].filetype = "http"

              local method = data.method or "N/A"
              local url = data.url or "N/A"
              local response_time = tonumber(data.response_time) or 0
              table.insert(output_lines, string.format("# %s %s (%.2fms)", method, url, response_time))

              local status = data.status or "N/A"
              table.insert(output_lines, string.format("HTTP/1.1 %s", status))

              if data.headers then
                for key, value in pairs(data.headers) do
                  table.insert(output_lines, string.format("%s: %s", key, value))
                end
              end

              table.insert(output_lines, "")

              local content = utils.format(data.body, type)
              if content then
                for _, line in ipairs(content) do
                  table.insert(output_lines, line)
                end
              else
                table.insert(output_lines, data.body or "No content")
              end
            end

            vim.api.nvim_buf_set_lines(split.bufnr, 0, -1, false, output_lines)

            split:map("n", _HURL_GLOBAL_CONFIG.mappings.close, function()
              quit()
            end)
          end

          M.clear = function()
            if not split.winid then
              return
            end
            vim.api.nvim_buf_set_lines(split.bufnr, 0, -1, false, {
              "Processing...",
              "",
              _HURL_GLOBAL_CONFIG.last_hurl_command or "N/A",
            })
          end

          return M
        end)()
      '';
      autoCmd = [
        {
          event = "FileType";
          pattern = "hurl";
          callback.__raw = ''
            function()
              vim.keymap.set({ "n" }, "<CR>", "<Cmd>HurlRunnerAt<CR>", { buffer = true, desc = "Run hurl request" })
            end
          '';
        }
        {
          event = "FileType";
          pattern = "hurl";
          callback.__raw = ''
            function()
              vim.keymap.set({ "n" }, "<Leader>rl", "<Cmd>HurlShowLastResponse<CR>", { buffer = true, desc = "Show last hurl response" })
            end
          '';
        }
        {
          event = "FileType";
          pattern = "hurl";
          callback.__raw = ''
            function()
              vim.keymap.set({ "n" }, "<Leader>rv", "<Cmd>HurlManageVariable<CR>", { buffer = true, desc = "Manage hurl variable" })
            end
          '';
        }
        {
          event = "FileType";
          pattern = "hurl";
          callback.__raw = ''
            function()
              vim.keymap.set({ "n" }, "<Leader>re", function()
                require("snacks").picker.files({
                  title = "Select Hurl Env File",
                  args = { "--glob", "*.env" },
                  ignored = true,
                  confirm = function(picker, item)
                    picker:close()
                    if item then
                      vim.cmd("HurlSetEnvFile " .. item.file)
                    end
                  end,
                })
              end, { buffer = true, desc = "Set hurl env file" })
            end
          '';
        }
      ];
    };
  };
}
