{ config, pkgs, ... }:

{

  imports = [
    ./nvim
    # ./firefox
  ];

  home.packages = with pkgs; [
    oh-my-zsh
    powerline-go
    powerline
    fzf
    gnupg
    adoptopenjdk-hotspot-bin-8
    tmux
    tmuxPlugins.power-theme
    reattach-to-user-namespace
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
    rnix-lsp
    nix-prefetch-git
    gh
    nodejs-slim
    tig
    mpv
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    DIRENV_LOG_FORMAT = "";
    SBT_NATIVE_CLIENT = "true";
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      export EDITOR="vim";
      export DIRENV_LOG_FORMAT="";
      export SBT_NATIVE_CLIENT="true";
    '';
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };

  programs.powerline-go = {
    enable = true;
    modulesRight = [ "nix-shell" ];
    settings = {
      hostname-only-if-ssh = true;
    };
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf.enable = true;

  programs.bat.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
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
    extraConfig = ''
      # use PREFIX | to split window horizontally and PREFIX - to split vertically
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Setup 'v' to begin selection as in Vim
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      # resize panes using PREFIX H, J, K, L
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

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
      set -g visual-activity on
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Hack Nerd Font";
        };
      };
      colors = {
        primary = {
          background = "#303030";
        };
      };
    };
  };
}
