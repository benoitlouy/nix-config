userConf: { config, pkgs, ... }:

{

  imports = [
    ./nvim
  ];

  home.packages = with pkgs; [
    oh-my-zsh
    powerline-go
    fzf
    gnupg
    jdk8
    coursier
    tmux
    tmuxPlugins.power-theme
    reattach-to-user-namespace
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
    rnix-lsp
    nix-prefetch-git
    nodejs-slim
    tig
    firefox-bin
    ripgrep
    fd
    font-awesome
    chatty-twitch
    youtube-dl
    terraform
    tree-sitter
    kubectl
    openconnect
    gnused
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    DIRENV_LOG_FORMAT = "";
    # SBT_NATIVE_CLIENT = "true";
  };

  programs.git = {
    enable = true;
    userName = "Benoit Louy";
    userEmail = "${userConf.email}";
    signing = {
      key = "${userConf.email}";
      signByDefault = true;
    };
    extraConfig = {
      pull.rebase = true;
      rerere.enabled = true;
      remote."origin".prune = true;
    };
    ignores = [
      ".bloop/"
      ".hydra/"
      "project/hydra.sbt"
      ".vscode/"
      "project/metals.sbt"
      ".metals/"
      ".DS_Store"
      "project/**/metals.sbt"
      ".bsp/"
      ".envrc"
      ".direnv"
    ];
  };

  programs.gh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      export EDITOR="vim"
      declare -a VPNDNS
      export VPNDNS=(
        "10.8.204.17"
        "192.168.1.1"
      )
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
      # {
      #   name = "forgit";
      #   file = "forgit.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "wfxr";
      #     repo = "forgit";
      #     rev = "7b26cd46ac768af51b8dd4b84b6567c4e1c19642";
      #     sha256 = "18whb6bv69rl2aw3gi0bhwjqpygmc1jhp8d1y54ygjd2f0psbxjb";
      #   };
      # }
    ];
    shellAliases = {
      netdevice = "networksetup -listnetworkserviceorder | grep $(echo 'show State:/Network/Global/IPv4' | scutil | grep PrimaryInterface | cut -d: -f2 | xargs echo) | cut -d: -f2 | cut -d, -f1 | sed -E 's/^\\s*//'";
      setdns = "networksetup -setdnsservers \"$(netdevice)\"";
      getdns = "networksetup -getdnsservers \"$(netdevice)\"";
    };
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
      sensible
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
      # window name
      set-option -g set-titles on
      set-option -g set-titles-string "#S / #W"

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
      window = {
        decorations = "none";
      };
    };
  };

  programs.awscli = {
    package = pkgs.awscli2;
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    awsVault = {
      enable = true;
      prompt = "ykman";
      backend = "keychain";
      passPrefix = "aws_vault/";
    };
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      youtube-quality
    ];
    config = {
      no-border = "";
    };
  };

  programs.streamlink = {
    enable = true;
    config = ''
      player=mpv
      twitch-low-latency
    '';
  };

}
