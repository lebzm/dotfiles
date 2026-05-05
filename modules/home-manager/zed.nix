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
  options.modules.zed = {
    enable = lib.mkEnableOption "zed";
    nix.enable = lib.mkEnableOption "nix";
    go.enable = lib.mkEnableOption "go";
    gleam.enable = lib.mkEnableOption "gleam";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        programs.zed-editor = {
          enable = true;
          extensions = [
            "catppuccin"
            "catppuccin-icons"
            "git-firefly"
            "make"
            "editorconfig"
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
          };
        };
      }

      (lib.mkIf cfg.nix.enable {
        home.packages = with pkgs; [
          nixd
          nixfmt
        ];
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
      })

      (lib.mkIf cfg.go.enable {
        home.packages = with pkgs; [
          go
          gopls
          delve
          gofumpt
        ];
        programs.zed-editor = {
          userSettings = {
            lsp.gopls.initialization_options = {
              gofumpt = true;
              usePlaceholders = true;
            };
          };
        };
      })

      (lib.mkIf cfg.gleam.enable {
        home.packages = with pkgs; [
          gleam
          rebar3
          erlang
          bun
        ];
        programs.zed-editor = {
          extensions = [ "gleam" ];
        };
      })

    ]
  );
}
