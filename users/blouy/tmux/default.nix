{ pkgs, config, ... }:

let
  tmux_conf = {
    "colemak-dh" = builtins.readFile ./tmux_colemakdh.conf;
    "qwerty" = builtins.readFile ./tmux_qwerty.conf;
  }."${config.keymap}";

  tmux_vim_navigator_conf = {
    "colemak-dh" = builtins.readFile ./vim_tmux_navigator_colemakdh.conf;
    "qwerty" = builtins.readFile ./vim_tmux_navigator_qwerty.conf;
  }."${config.keymap}";
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = vim-tmux-navigator;
        extraConfig = tmux_vim_navigator_conf;
      }
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          set -g @dracula-plugins "cpu-usage ram-usage time"
        '';
      }
    ];
    extraConfig = tmux_conf + ''
      # set -g default-command "${pkgs.zsh}/bin/zsh"
      # set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      # for vim-gitgutter to work properly
      set -g focus-events on

      # window name
      set-option -g set-titles on
      set-option -g set-titles-string "#S / #W"

      # use PREFIX | to split window horizontally and PREFIX - to split vertically
      bind Enter split-window -h -c "#{pane_current_path}"
      bind BSpace split-window -v -c "#{pane_current_path}"

      bind n next-window
      bind m  previous-window

      # Setup 'v' to begin selection as in Vim
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      # clear history
      bind C-l send-keys C-l
      bind C-k send-keys -R \; send-keys C-l \; clear-history

      # ----------------------
      # set some pretty colors
      # ----------------------
      # set pane colors - hilight the active pane
      set-option -g pane-border-style fg=colour235
      set-option -g pane-active-border-style fg=colour240
      # set-option -g pane-border-fg colour235 #base02
      # set-option -g pane-active-border-fg colour240 #base01

      # colorize messages in the command line
      set-option -g message-style bg=black,fg=brightred
      # set-option -g message-bg black #base02
      # set-option -g message-fg brightred #orange

      # ----------------------
      # Status Bar
      # -----------------------
      set-option -g status-position top    # position the status bar at top of screen

      # visual notification of activity in other windows
      setw -g monitor-activity on
      set -g visual-activity off
    '';
  };


}
