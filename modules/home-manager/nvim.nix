{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nvim;
  treesitter = config.programs.nixvim.plugins.treesitter.package.builtGrammars;
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
          viAlias = true;
          vimAlias = true;
          clipboard.register = "unnamedplus";
          globals.mapleader = " ";
          opts = {
            signcolumn = "yes";
            wrap = false;
            tabstop = 4;
            shiftwidth = 4;
            fillchars.eob = " ";
          };
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
            mini-icons.enable = true;
            noice = {
              enable = true;
              settings = {
                presets = {
                  bottom_search = true;
                  command_palette = true;
                  lsp_doc_border = true;
                };
                cmdline.format.filter.title = " Shell ";
                routes = [
                  {
                    filter = {
                      event = "msg_show";
                      kind = [
                        "bufwrite"
                        "undo"
                      ];
                    };
                    view = "mini";
                  }
                  {
                    filter = {
                      event = "msg_show";
                      kind = [
                        "echo"
                        "echomsg"
                        "echoerr"
                        "lua_print"
                        "lua_error"
                        "shell_out"
                        "shell_err"
                        "shell_ret"
                      ];
                    };
                    view = "split";
                  }
                ];
                lsp.override = {
                  "vim.lsp.util.convert_input_to_markdown_lines" = true;
                  "vim.lsp.util.stylize_markdown" = true;
                };
              };
            };
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
                label.uppercase = false;
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
            snacks.enable = true;
          };
          keymaps = [
            {
              key = "<leader>ff";
              action.__raw = ''function() require("snacks").picker.files() end'';
              mode = [ "n" ];
            }
          ];
        };
      }

      # git
      {
        programs.nixvim = {
          plugins = {
            gitsigns.enable = true;
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

      # lang
      {
        programs.nixvim = {
          lsp = {
            inlayHints.enable = true;
            keymaps = [
              {
                key = "gd";
                lspBufAction = "definition";
              }
              {
                key = "gt";
                lspBufAction = "type_definition";
              }
              {
                key = "gr";
                lspBufAction = "references";
              }
              {
                key = "gi";
                lspBufAction = "implementation";
              }
              {
                key = "K";
                lspBufAction = "hover";
              }
            ];
          };
          plugins = {
            lspconfig.enable = true;
            conform-nvim = {
              enable = true;
              autoInstall.enable = true;
              settings.format_on_save = {
                lsp_format = "fallback";
                timeout_ms = 500;
              };
            };
            treesitter = {
              enable = true;
              highlight.enable = true;
              indent.enable = true;
              # folding.enable = true;
            };
          };
        };
      }

      # lang.http
      {
        programs.nixvim = {
          autoCmd = [
            {
              event = "FileType";
              pattern = "http";
              callback.__raw = ''
                function()
                  vim.keymap.set({ "n" }, "<cr>", function() require("kulala").run() end, { buffer = true, desc = "Run kulala request" })
                end
              '';
            }
            {
              event = "FileType";
              pattern = "http";
              callback.__raw = ''
                function()
                  vim.keymap.set({ "n" }, "e", function() require("kulala").set_selected_env() end, { buffer = true, desc = "Select environment" })
                end
              '';
            }
          ];
          plugins = {
            kulala = {
              enable = true;
              settings = {
                winbar = false;
                default_view.__raw = ''
                  function(response)
                    local config = require("kulala.config")
                    local ui = require("kulala.ui")
                    local globals = require("kulala.globals")
                    local ui_utils = require("kulala.ui.utils")

                    -- Set these before show_body() runs
                    config.get().ui.show_request_summary = false
                    config.get().kulala_keymaps = false

                    local http_status = {
                      [100] = "Continue", [101] = "Switching Protocols", [102] = "Processing",
                      [200] = "OK", [201] = "Created", [202] = "Accepted", [203] = "Non-Authoritative Info",
                      [204] = "No Content", [205] = "Reset Content", [206] = "Partial Content",
                      [300] = "Multiple Choices", [301] = "Moved Permanently", [302] = "Found",
                      [303] = "See Other", [304] = "Not Modified", [307] = "Temporary Redirect",
                      [308] = "Permanent Redirect",
                      [400] = "Bad Request", [401] = "Unauthorized", [402] = "Payment Required",
                      [403] = "Forbidden", [404] = "Not Found", [405] = "Method Not Allowed",
                      [406] = "Not Acceptable", [407] = "Proxy Auth Required", [408] = "Request Timeout",
                      [409] = "Conflict", [410] = "Gone", [411] = "Length Required",
                      [412] = "Precondition Failed", [413] = "Payload Too Large", [414] = "URI Too Long",
                      [415] = "Unsupported Media Type", [416] = "Range Not Satisfiable",
                      [417] = "Expectation Failed", [418] = "I'm a Teapot", [422] = "Unprocessable Entity",
                      [423] = "Locked", [424] = "Failed Dependency", [425] = "Too Early",
                      [426] = "Upgrade Required", [429] = "Too Many Requests",
                      [431] = "Request Header Fields Too Large",
                      [500] = "Internal Server Error", [501] = "Not Implemented",
                      [502] = "Bad Gateway", [503] = "Service Unavailable", [504] = "Gateway Timeout",
                      [505] = "HTTP Version Not Supported", [511] = "Network Auth Required",
                    }

                    -- Save our custom view so show_body() doesn't eat it
                    local saved = config.get().default_view
                    ui.show_body()
                    config.get().default_view = saved

                    local buf = vim.fn.bufnr(globals.UI_ID)
                    if not buf or buf < 0 then return end

                    -- Kill the "? - help" overlay
                    vim.api.nvim_buf_clear_namespace(
                      buf, vim.api.nvim_create_namespace("kulala_virtual_text"), 0, -1
                    )

                    -- Header line
                    local headers_tbl = response.headers_tbl or {}
                    local header_lines = {}
                    local keys = vim.tbl_keys(headers_tbl)
                    table.sort(keys)
                    for _, k in ipairs(keys) do
                      local v = headers_tbl[k]
                      if type(v) == "table" then
                        for _, sv in ipairs(v) do
                          table.insert(header_lines, k .. ": " .. sv)
                        end
                      else
                        table.insert(header_lines, k .. ": " .. v)
                      end
                    end

                    -- Status line
                    local code_num = tonumber(response.response_code)
                    local has_http = code_num and code_num >= 100 and code_num <= 599

                    local icons = config.get().icons.inlay
                    local icon = has_http and (code_num >= 200 and code_num < 300) and icons.done or icons.error

                    local duration = response.duration and ui_utils.pretty_ms(response.duration) or ""

                    local code_display
                    if has_http then
                      local status_text = http_status[code_num]
                      code_display = status_text and ("%s %s"):format(code_num, status_text) or tostring(code_num)
                    elseif response.errors and response.errors ~= "" then
                      local err_line = vim.split(response.errors, "\n")[1]
                      err_line = vim.trim(err_line)
                      code_display = #err_line > 60 and err_line:sub(1, 60) .. "..." or err_line
                    else
                      code_display = "ERR_CONNECT"
                    end

                    local line1 = ("%s %s | %s"):format(icon, code_display, duration)
                    local line2 = ("%s %s"):format(response.method or "", response.url or "")

                    -- Prepend: status + blank + headers + blank
                    local pre_lines = { line1, line2, "" }
                    for _, hl in ipairs(header_lines) do
                      table.insert(pre_lines, hl)
                    end
                    table.insert(pre_lines, "")

                    vim.api.nvim_buf_set_lines(buf, 0, 0, false, pre_lines)

                    -- Neutralise JSON highlighting on non-body lines
                    local ns = vim.api.nvim_create_namespace("kulala_neutral")
                    for line = 0, #pre_lines - 1 do
                      vim.api.nvim_buf_add_highlight(buf, ns, "Normal", line, 0, -1)
                    end

                    -- Highlight icon
                    local icon_hl = has_http and (code_num >= 200 and code_num < 300)
                      and config.get().icons.doneHighlight
                      or config.get().icons.errorHighlight
                    if icon_hl then
                      vim.api.nvim_buf_add_highlight(buf, -1, icon_hl, 0, 0, #icon)
                    end

                    local win = vim.fn.win_findbuf(buf)[1]
                    if win then
                      vim.api.nvim_win_set_cursor(win, { 1, 0 })
                    end
                  end
                '';
              };
            };
          };
        };
      }

      # lang.nix
      {
        programs.nixvim = {
          lsp.servers = {
            nixd = {
              enable = true;
              config.settings.nixd = {
                nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
                # options.home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.bzm.options";
                # options.nix-darwin.expr = "(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.amartha.options";
              };
            };
          };
          plugins = {
            conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
            treesitter.grammarPackages = with treesitter; [ nix ];
          };
        };
      }

      # lang.go
      {
        programs.nixvim = {
          lsp.servers = {
            gopls.enable = true;
          };
          plugins = {
            conform-nvim.settings.formatters_by_ft.go = [ "gofumpt" ];
            treesitter.grammarPackages = with treesitter; [ go ];
          };
        };
      }

    ]
  );
}
