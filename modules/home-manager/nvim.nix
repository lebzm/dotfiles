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
  options.modules.nvim = {
    enable = lib.mkEnableOption "nvim";
    dotfilesPath = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      # general
      {
        home.packages = with pkgs; [ nodejs ];
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
            ignorecase = true;
            smartcase = true;
          };
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
              key = "jj";
              action = "<C-\\><C-n>";
              mode = [ "t" ];
            }
            {
              key = "<C-h>";
              action = "<C-w>h";
              mode = [ "n" "x" ];
            }
            {
              key = "<C-j>";
              action = "<C-w>j";
              mode = [ "n" "x" ];
            }
            {
              key = "<C-k>";
              action = "<C-w>k";
              mode = [ "n" "x" ];
            }
            {
              key = "<C-l>";
              action = "<C-w>l";
              mode = [ "n" "x" ];
            }
          ];
        };
      }

      # ui
      {
        programs.nixvim = {
          colorschemes.catppuccin = {
            enable = true;
            settings.flavour = "mocha";
            settings.transparent_background = true;
            settings.float.transparent = true;
          };
          plugins = {
            lualine.enable = true;
            mini-icons = {
              enable = true;
              mockDevIcons = true;
            };
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
                        "echomsg"
                        "echoerr"
                      ];
                    };
                    view = "mini";
                  }
                  {
                    filter = {
                      event = "msg_show";
                      kind = [
                        "echo"
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
            mini-pairs.enable = true;
            snacks = {
              enable = true;
              settings = {
                input.enable = true;
                picker.enable = true;
                terminal = {
                  start_insert = false;
                  auto_insert = false;
                  auto_close = true;
                };
              };
            };
            neogit = {
              enable = true;
              settings = {
                kind = "vsplit";
                commit_editor = {
                  kind = "floating";
                  spell_check = false;
                };
              };
            };
            blink-cmp = {
              enable = true;
              settings = {
                completion = {
                  ghost_text.enabled = true;
                  menu.auto_show = false;
                  menu.border = "single";
                  documentation.window.border = "single";
                  documentation.auto_show = true;
                };
                keymap = {
                  preset = "none";
                  "<C-Space>" = [
                    "show"
                    "hide"
                  ];
                  "<Tab>" = [
                    "select_and_accept"
                    "fallback"
                  ];
                  "<C-n>" = [
                    "select_next"
                    "fallback_to_mappings"
                  ];
                  "<C-p>" = [
                    "select_prev"
                    "fallback_to_mappings"
                  ];
                  "<C-b>" = [
                    "scroll_documentation_up"
                    "fallback"
                  ];
                  "<C-f>" = [
                    "scroll_documentation_down"
                    "fallback"
                  ];
                };
              };
            };
          };
          keymaps = [
            {
              key = "<Leader>ff";
              action.__raw = ''function() require("snacks").picker.files() end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>tt";
              action.__raw = ''function() require("snacks").terminal() end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>gg";
              action.__raw = ''function() require("neogit").open() end'';
              mode = [
                "n"
                "x"
              ];
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

      # ai.opencode for work
      {
        home.packages = with pkgs.llm-agents; [ opencode ];
        programs.nixvim = {
          plugins.opencode.enable = true;
          keymaps = [
            # general
            {
              key = "<Leader><tab>";
              action.__raw = ''function() require("opencode").command("agent.cycle") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>oq";
              action.__raw = ''
                -- require to fire the command twice due to confirmation
                function()
                 require("opencode").command("session.interrupt")
                 require("opencode").command("session.interrupt")
                end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>os";
              action.__raw = ''function() require("opencode").select() end'';
              mode = [ "n" ];
            }

            # ask
            {
              key = "<Leader>oa";
              action.__raw = ''function() require("opencode").ask() end'';
              mode = [ "n" ];
            }
            {
              key = "<Leader>oa";
              action.__raw = ''function() require("opencode").ask("@this: ") end'';
              mode = [ "x" ];
            }

            # explain/review
            {
              key = "<Leader>od";
              action.__raw = ''function() require("opencode").prompt("Explain @diagnostics") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>oe";
              action.__raw = ''function() require("opencode").prompt("Explain @this and its context") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>or";
              action.__raw = ''function() require("opencode").prompt("Review @this for correctness and readability") end'';
              mode = [
                "n"
                "x"
              ];
            }

            # edit
            {
              key = "<Leader>of";
              action.__raw = ''function() require("opencode").prompt("Fix @diagnostics") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>oi";
              action.__raw = ''function() require("opencode").prompt("Implement @this") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>oo";
              action.__raw = ''function() require("opencode").prompt("Optimize @this for performance and readability") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>ot";
              action.__raw = ''function() require("opencode").prompt("Add tests for @this") end'';
              mode = [
                "n"
                "x"
              ];
            }
            {
              key = "<Leader>oc";
              action.__raw = ''function() require("opencode").prompt("Add comments documenting @this") end'';
              mode = [
                "n"
                "x"
              ];
            }
          ];
        };
      }

      # ai.pi for hacking
      {
        home.packages = with pkgs.llm-agents; [ pi ];
        programs.nixvim = {
          extraPlugins = with pkgs.vimPlugins; [ pi-nvim ];
          extraConfigLua = ''
            require("pi").setup({
              provider = "opencode-go",
              model = "kimi-k2.5";
            })
          '';
          keymaps = [
            # general
            {
              key = "<Leader>pq";
              action.__raw = ''function() require("pi").cancel() end'';
              mode = [
                "n"
                "x"
              ];
            }

            # ask
            {
              key = "<Leader>pa";
              action.__raw = ''function() require("pi").prompt_with_buffer() end'';
              mode = [ "n" ];
            }
            {
              key = "<Leader>pa";
              action.__raw = ''function() require("pi").prompt_with_selection() end'';
              mode = [ "x" ];
            }
          ];
        };
      }

      # lang
      {
        programs.nixvim = {
          diagnostic.settings = {
            virtual_text.current_line = true;
          };
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
              {
                key = "[d";
                action.__raw = "function() vim.diagnostic.jump({ count=-1 }) end";
                options.desc = "Previous diagnostic";
              }
              {
                key = "]d";
                action.__raw = "function() vim.diagnostic.jump({ count=1 }) end";
                options.desc = "Next diagnostic";
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
              # folding.enable = true; # TODO: enable folding and other related folding config
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
                  vim.keymap.set({ "n" }, "<CR>", function() require("kulala").run() end, { buffer = true, desc = "Run kulala request" })
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
                options.home-manager.expr = "(builtins.getFlake \"${cfg.dotfilesPath}/.config/dotfiles\").homeConfigurations.bzm.options";
                options.nix-darwin.expr = "(builtins.getFlake \"${cfg.dotfilesPath}/.config/dotfiles\").darwinConfigurations.amartha.options";
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
