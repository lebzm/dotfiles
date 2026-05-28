{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.zed;
in

{
  options.modules.zed.enable = lib.mkEnableOption "zed";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        programs.zed-editor = {
          enable = true;
          extensions = [
            "git-firefly"
            "editorconfig"
          ];
        };
        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;
      }

      # settings
      {
        programs.zed-editor = {
          extensions = [
            "catppuccin"
            "catppuccin-icons"
          ];
          mutableUserSettings = false;
          userSettings = {
            auto_update = false;
            telemetry.diagnostics = false;
            telemetry.metrics = false;
            theme = "Catppuccin Mocha - No Italics";
            icon_theme = "Catppuccin Mocha";
            buffer_font_family = "FiraCode Nerd Font";
            buffer_font_size = 13;
            base_keymap = "VSCode";
            vim_mode = true;
            relative_line_numbers = "enabled";
            auto_signature_help = true;
          };
        };
      }

      # keymaps
      {
        programs.zed-editor = {
          mutableUserKeymaps = true; # TODO: disable mutable user keymaps once stable
          userKeymaps = [
            {
              context = "vim_mode == insert";
              bindings = {
                "j j" = "vim::NormalBefore";
              };
            }
          ];
        };
      }

      # build.nix
      {
        programs.zed-editor = {
          extensions = [ "nix" ];
          userSettings = {
            languages.Nix.language_servers = [
              "nixd"
              "!nil"
            ];
            lsp.nixd.settings = {
              formatting.command = [ "nixfmt" ];
              nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
            };
          };
        };
        home.packages = with pkgs; [
          nixd
          nixfmt
        ];
      }

      # build.Makefile
      {
        programs.zed-editor = {
          extensions = [ "make" ];
        };
      }

      # build.Dockerfile
      # TODO: more Dockerfile configuration
      {
        programs.zed-editor = {
          extensions = [
            "dockerfile"
            "docker-compose"
          ];
        };
        services.podman.enable = true;
        programs.zsh.shellAliases = {
          docker = "podman";
        };
      }

      # TODO: configure conf
      # conf.json
      # conf.toml
      # conf.xml
      # conf.yaml
      {
        programs.zed-editor = {
          extensions = [
            "json"
            "toml"
            "xml"
            "yaml"
          ];
        };
      }

      # TODO: configure web
      # web.html
      # web.css
      # web.js
      {
        programs.zed-editor = {
          extensions = [
            "html"
            "css"
            "js"
          ];
        };
      }

      # lang.go
      {
        programs.zed-editor = {
          extensions = [ "go" ];
          userSettings = {
            lsp.gopls.initialization_options = {
              gofumpt = true;
            };
          };
        };
        home.packages = with pkgs; [
          go
          gopls
          delve
          gofumpt
        ];
      }

      # lang.gleam
      {
        programs.zed-editor = {
          extensions = [ "gleam" ];
        };
        home.packages = with pkgs; [
          gleam
          rebar3
          erlang
          bun
        ];
      }

      # lang.odin
      {
        programs.zed-editor = {
          extensions = [ "odin" ];
        };
        home.packages = with pkgs; [
          odin
          ols
        ];
      }
    ]
  );
}
