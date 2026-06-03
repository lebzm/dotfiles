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
          opts.signcolumn = "yes";
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
            noice = {
              enable = true;
              settings.presets = {
                bottom_search = true;
                command_palette = true;
                # long_message_to_split = false;
                # inc_rename = false;
                # lsp_doc_border = false;
              };
            };
            mini-icons.enable = true;
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
