{ config, lib, ... }:

let
  cfg = config.modules.term.zsh;
in

{
  options.modules.term.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Runs before compinit — configure completion behavior here
      completionInit = ''
        # Force menu selection on the first Tab press
        setopt menu_complete

        # Enable navigable menu completion with first item selected
        zstyle ':completion:*' menu select=1

        # Never ask "do you wish to see all X possibilities", always show the menu
        LISTMAX=-1
      '';

      # Runs after compinit — bindkeys that need complist loaded
      initContent = ''
        # Ensure complist is loaded so the menuselect keymap exists
        zmodload zsh/complist

        # In the completion menu:
        #   Tab   -> accept the selected item
        #   C-n   -> next item
        #   C-p   -> previous item
        bindkey -M menuselect '^I' accept-line
        bindkey -M menuselect '^N' down-line-or-history
        bindkey -M menuselect '^P' up-line-or-history
      '';
    };
  };
}
