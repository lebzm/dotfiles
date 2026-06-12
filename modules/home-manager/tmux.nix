{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.tmux;
in

{
  options.modules.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
      bat
      zoxide
    ];
    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      keyMode = "vi";
      disableConfirmationPrompt = true;
      sensibleOnTop = true;
      mouse = true;
      escapeTime = 0;
      baseIndex = 1;
      terminal = "tmux-256color";
      extraConfig = ''
        set -g extended-keys on
        set -ag terminal-features ",*:extkeys"
        set -g renumber-windows on

        bind c new-window -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
      '';
      plugins = with pkgs.tmuxPlugins; [
        yank
        {
          plugin = session-wizard;
          extraConfig = ''
            set -g @session-wizard "f"
            set -g @session-wizard-height 50
            set -g @session-wizard-width 50
            set -g @session-wizard-mode "directory"
          '';
        }
        {
          plugin = vim-tmux-navigator;
          extraConfig = ''
            # restoring clear screen (C-l)
            bind C-l send-keys "C-l"
            # restoring SIGQUIT (C-\)
            bind C-\\ send-keys "C-\\"
          '';
        }
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g status-position top
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_status_background "none"
            set -g @catppuccin_window_status_style "basic"
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_text "#{b:pane_current_path}"
            set -g @catppuccin_window_current_text "#{b:pane_current_path}"
            set -g @catppuccin_directory_text " #(tmux display-message -p -F \"#{pane_current_path}\" | sed \"s|''${HOME}|~|g\")"

            set -g status-left-length 100
            set -g status-left ""

            set -g status-right-length 100
            set -g status-right "#{E:@catppuccin_status_directory}"
            set -ag status-right "#{E:@catppuccin_status_session}"
          '';
        }
      ];
    };
  };
}
