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
    programs.tmux = {
      enable = true;
      prefix = "C-\\;";
      keyMode = "vi";
      newSession = true;
      disableConfirmationPrompt = true;
      sensibleOnTop = true;
      mouse = true;
      escapeTime = 0;
      baseIndex = 1;
      terminal = "tmux-256color";
      extraConfig = ''
        set -g renumber-windows on

        bind r source-file ~/.config/tmux/tmux.conf

        bind c new-window -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
      '';
      plugins = with pkgs.tmuxPlugins; [
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
