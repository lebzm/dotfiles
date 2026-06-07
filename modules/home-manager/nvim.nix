{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nvim;
  treesitterGrammars = config.programs.nixvim.plugins.treesitter.package.builtGrammars;

  normal = [ "n" ];
  insert = [ "i" ];
  command = [ "c" ];
  visual = [ "x" ];
  operator = [ "o" ];
  terminal = [ "t" ];

  border_style = "rounded";

  nixvim = {
    home.packages = with pkgs; [
      nodejs
      prettier
    ];
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
          mode = insert ++ command;
        }
        {
          key = "jj";
          action = "<C-\\><C-n>";
          mode = terminal;
        }
        {
          key = "<Leader>w";
          action = "<Cmd>w<CR>";
          mode = normal;
        }
        {
          key = "<Leader>x";
          action = "<Cmd>bd<CR>";
          mode = normal;
        }
      ];
    };
  };

  ui_colorscheme = {
    programs.nixvim = {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = true;
          float.transparent = true;
        };
      };
    };
  };

  ui_icons = {
    programs.nixvim = {
      plugins.mini-icons = {
        enable = true;
        mockDevIcons = true;
      };
    };
  };

  ui_statusline = {
    programs.nixvim = {
      plugins.lualine.enable = true;
    };
  };

  ui_noice = {
    programs.nixvim = {
      plugins.noice = {
        enable = true;
        settings = {
          presets.bottom_search = true;
          presets.command_palette = true;
          presets.lsp_doc_border = true;
          cmdline.format.filter.title = " Shell ";
          routes = [
            {
              filter = {
                event = "msg_show";
                kind = [
                  "bufwrite"
                  "undo"
                  "echo"
                  "echomsg"
                  "echoerr"
                  "lua_print"
                  "lua_error"
                ];
              };
              view = "mini";
            }
            {
              filter = {
                event = "msg_show";
                kind = [
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

  ui_snacks = {
    programs.nixvim.plugins.snacks = {
      enable = true;
      settings.input.enable = true;
    };
  };

  motion = {
    programs.nixvim = {
      plugins.flash = {
        enable = true;
        settings = {
          modes.search.enabled = false;
          modes.char.enabled = false;
          prompt.enabled = false;
          label.uppercase = false;
        };
      };
      keymaps = [
        {
          key = "s";
          action.__raw = ''function() require("flash").jump() end'';
          mode = normal ++ visual ++ operator;
        }
        {
          key = "S";
          action.__raw = ''function() require("flash").treesitter() end'';
          mode = normal ++ visual ++ operator;
        }
        {
          key = "gh";
          action = "<C-w>h";
          mode = normal ++ visual;
        }
        {
          key = "gj";
          action = "<C-w>j";
          mode = normal ++ visual;
        }
        {
          key = "gk";
          action = "<C-w>k";
          mode = normal ++ visual;
        }
        {
          key = "gl";
          action = "<C-w>l";
          mode = normal ++ visual;
        }
      ];
    };
  };

  completion = {
    programs.nixvim = {
      plugins.blink-cmp = {
        enable = true;
        settings = {
          completion = {
            ghost_text.enabled = true;
            menu.auto_show = false;
            menu.border = border_style;
            documentation.window.border = border_style;
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
  };

  autopairs = {
    programs.nixvim = {
      plugins.mini-pairs.enable = true;
    };
  };

  git = {
    programs.nixvim = {
      plugins.gitsigns.enable = true;
      plugins.neogit = {
        enable = true;
        settings = {
          kind = "vsplit";
          commit_editor.kind = "floating";
          commit_editor.spell_check = false;
        };
      };
      keymaps = [
        {
          key = "<Leader>gg";
          action.__raw = ''function() require("neogit").open() end'';
          mode = normal ++ visual;
        }
      ];
    };
  };

  dep_treesitter = {
    programs.nixvim = {
      plugins.treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        grammarPackages = with treesitterGrammars; [ regex ];
        # folding.enable = true; # TODO: enable folding and other related folding config
      };
    };
  };

  dep_format = {
    programs.nixvim = {
      plugins.conform-nvim = {
        enable = true;
        autoInstall.enable = true;
        settings.format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
      };
    };
  };

  dep_lsp = {
    programs.nixvim = {
      plugins.lspconfig.enable = true;
      diagnostic.settings.virtual_text.current_line = true;
      lsp.inlayHints.enable = true;
      autoCmd = [
        {
          event = "LspAttach";
          callback.__raw = ''
            -- prefer 2 combination instead of 3 for lsp
            -- remove default vim.lsp mapping
            function()
              pcall(vim.keymap.del, "n", "grn")
              pcall(vim.keymap.del, "n", "grr")
              pcall(vim.keymap.del, {"n", "x"}, "gra")
              pcall(vim.keymap.del, "n", "gri")
              pcall(vim.keymap.del, "n", "g0")
              pcall(vim.keymap.del, "n", "grt")
              pcall(vim.keymap.del, "n", "grx")
            end
          '';
        }
      ];
      lsp.keymaps = [
        {
          key = "gd";
          action.__raw = ''function() require("snacks").picker.lsp_definitions() end'';
          mode = normal;
        }
        {
          key = "gD";
          action.__raw = ''function() require("snacks").picker.lsp_declarations() end'';
          mode = normal;
        }
        {
          key = "gt";
          action.__raw = ''function() require("snacks").picker.lsp_type_definitions() end'';
          mode = normal;
        }
        {
          key = "gr";
          action.__raw = ''function() require("snacks").picker.lsp_references() end'';
          mode = normal;
        }
        {
          key = "gi";
          action.__raw = ''function() require("snacks").picker.lsp_implementations() end'';
          mode = normal;
        }
        {
          key = "go";
          action.__raw = ''function() require("snacks").picker.lsp_symbols() end'';
          mode = normal;
        }
        {
          key = "gp";
          action.__raw = ''function() require("snacks").picker.lsp_workspace_symbols() end'';
          mode = normal;
        }
        {
          key = "g.";
          lspBufAction = "code_action";
          mode = normal;
        }
        {
          key = "R";
          lspBufAction = "rename";
          mode = normal;
        }
        {
          key = "K";
          lspBufAction = "hover";
          mode = normal;
        }
        {
          key = "[d";
          action.__raw = "function() vim.diagnostic.jump({ count=-1 }) end";
          mode = normal;
        }
        {
          key = "]d";
          action.__raw = "function() vim.diagnostic.jump({ count=1 }) end";
          mode = normal;
        }
      ];
    };
  };

  dep_test = {
    programs.nixvim = {
      plugins.neotest = {
        enable = true;
        settings.floating.border = border_style;
      };
      autoCmd = [
        {
          event = "FileType";
          pattern = "neotest-output";
          callback.__raw = ''
            function()
              vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true, silent = true })
            end
          '';
        }
        {
          event = "FileType";
          pattern = "neotest-summary";
          callback.__raw = ''
            function()
              vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true, silent = true })
            end
          '';
        }
      ];
      keymaps = [
        {
          key = "<leader>t.";
          action.__raw = ''function() require("neotest").run.run() end'';
          mode = normal;
        }
        {
          key = "<leader>tf";
          action.__raw = ''function() require("neotest").run.run(vim.fn.expand("%")) end'';
          mode = normal;
        }
        {
          key = "<leader>tm";
          action.__raw = ''function() require("neotest").run.run(vim.fn.expand("%:p:h")) end'';
          mode = normal;
        }
        {
          key = "<leader>tp";
          action.__raw = ''function() require("neotest").run.run(vim.fn.getcwd()) end'';
          mode = normal;
        }
        {
          key = "<leader>tl";
          action.__raw = ''function() require("neotest").run.run_last() end'';
          mode = normal;
        }
        {
          key = "<leader>tt";
          action.__raw = ''function() require("neotest").summary.toggle() end'';
          mode = normal;
        }
        {
          key = "T";
          action.__raw = ''
            function()
              require("neotest").output.open({
                enter = false,
                auto_close = true,
              })
            end
          '';
          mode = normal;
        }
        {
          key = "<leader>ts";
          action.__raw = ''function() require("neotest").run.stop() end'';
          mode = normal;
        }
      ];
    };
  };

  lang_nix = {
    programs.nixvim = {
      plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ nix ];
      lsp.servers.nixd = {
        enable = true;
        config.settings.nixd = {
          nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
          options.home-manager.expr = "(builtins.getFlake \"${cfg.dotfilesPath}/.config/dotfiles\").homeConfigurations.bzm.options";
          options.nix-darwin.expr = "(builtins.getFlake \"${cfg.dotfilesPath}/.config/dotfiles\").darwinConfigurations.amartha.options";
        };
      };
    };
  };

  lang_go = {
    programs.nixvim = {
      plugins.conform-nvim.settings.formatters_by_ft.go = [ "gofumpt" ];
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ go ];
      lsp.servers.gopls.enable = true;
      plugins.neotest.adapters.golang.enable = true;
    };
  };

  tool_picker = {
    home.packages = with pkgs; [
      ripgrep
      fd
    ];
    programs.nixvim = {
      plugins.snacks.settings.picker.enable = true;
      keymaps = [
        {
          key = "<Leader>f";
          action.__raw = ''function() require("snacks").picker.files() end'';
          mode = normal ++ visual;
        }
        {
          key = "<Leader>b";
          action.__raw = ''function() require("snacks").picker.buffers() end'';
          mode = normal ++ visual;
        }
        {
          key = "<Leader>p";
          action.__raw = ''function() require("snacks").picker.projects() end'';
          mode = normal ++ visual;
        }
        {
          key = "<Leader>/";
          action.__raw = ''function() require("snacks").picker.grep() end'';
          mode = normal ++ visual;
        }
        {
          key = "?h";
          action.__raw = ''function() require("snacks").picker.help() end'';
          mode = normal ++ visual;
        }
        {
          key = "?k";
          action.__raw = ''function() require("snacks").picker.keymaps() end'';
          mode = normal ++ visual;
        }
      ];
    };
  };

  tool_explorer = {
    programs.nixvim = {
      plugins.snacks.settings.explorer.enable = true;
      keymaps = [
        {
          key = "<Leader>e";
          action.__raw = ''function() require("snacks").explorer() end'';
          mode = normal ++ visual;
        }
      ];
    };
  };

  tool_terminal = {
    programs.nixvim = {
      plugins.snacks.settings.terminal = {
        start_insert = true;
        auto_insert = false;
        auto_close = true;
      };
      keymaps = [
        {
          key = "<S-CR>";
          action.__raw = ''function() require("snacks").terminal() end'';
          mode = normal ++ visual;
        }
      ];
    };
  };

  tool_hurl = {
    programs.nixvim = {
      plugins.hurl.enable = true;
      plugins.render-markdown.enable = true; # TODO: this is optional, might move to a dedicated section
      plugins.conform-nvim.settings.formatters_by_ft.hurl = [ "hurlfmt" ];
      plugins.treesitter.grammarPackages = with treesitterGrammars; [ hurl ];
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

  ai_opencode = {
    home.packages = with pkgs.llm-agents; [ opencode ];
    programs.nixvim = {
      plugins.opencode.enable = true;
      keymaps = [
        {
          key = "<Leader><Tab>";
          action.__raw = ''function() require("opencode").command("agent.cycle") end'';
          mode = normal;
        }
        {
          key = "<Leader>o";
          action.__raw = ''function() require("opencode").select() end'';
          mode = normal;
        }
        {
          key = "<Leader>a";
          action.__raw = ''function() require("opencode").ask() end'';
          mode = normal;
        }
        {
          key = "<Leader>a";
          action.__raw = ''function() require("opencode").ask("@this: ") end'';
          mode = visual;
        }
      ];
    };
  };

  ai_pi = {
    home.packages = with pkgs.llm-agents; [ pi ];
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [ pi-nvim ];
      extraConfigLua = ''
        require("pi").setup({
          provider = "opencode-go",
          model = "kimi-k2.5";
        })
      '';
    };
  };

in

{
  options.modules.nvim = {
    enable = lib.mkEnableOption "nvim";
    dotfilesPath = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      nixvim

      ui_colorscheme
      ui_icons
      ui_statusline
      ui_noice
      ui_snacks

      motion
      completion
      autopairs

      git

      dep_treesitter
      dep_format
      dep_lsp
      dep_test

      lang_nix
      lang_go

      tool_picker
      tool_explorer
      tool_terminal
      tool_hurl

      ai_opencode
      ai_pi
    ]
  );
}
