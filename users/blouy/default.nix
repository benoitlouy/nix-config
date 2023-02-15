userConf: hostConf: { config, pkgs, ... }:

let
  workPackages = with pkgs; [
    devx
    vpn
  ];
  addtlPackages = if hostConf.isWork then workPackages else [ ];
in
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
    terraform-ls
    jq
    ctop
    smithy-language-server
    silicon
  ] ++ addtlPackages;

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
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
      export VI_MODE_SET_CURSOR=true
      export SHELL=${pkgs.zsh}/bin/zsh
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
          rev = "v0.5.0";
          hash = "sha256-IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
        };
      }
      # {
      #   name = "zsh-vi-mode";
      #   file = "zsh-vi-mode.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "jeffreytse";
      #     repo = "zsh-vi-mode";
      #     rev = "v0.9.0";
      #     hash = "sha256-KQ7UKudrpqUwI6gMluDTVN0qKpB15PI5P1YHHCBIlpg=";
      #   };
      # }
      # {
      #   name = "forgit";
      #   file = "forgit.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "wfxr";
      #     repo = "forgit";
      #     rev = "25789d2198f364a8e4a942cf8493fae2ef7b9fe4";
      #     hash = "sha256-ha456LUCUctUn8WAThDza437U5iyUkFirQ2UBtrrROg=";
      #   };
      # }
    ];
    shellAliases = {
      netdevice = "networksetup -listnetworkserviceorder | grep $(echo 'show State:/Network/Global/IPv4' | scutil | grep PrimaryInterface | cut -d: -f2 | xargs echo) | cut -d: -f2 | cut -d, -f1 | sed -E 's/^\\s*//'";
      setdns = "networksetup -setdnsservers \"$(netdevice)\"";
      getdns = "networksetup -getdnsservers \"$(netdevice)\"";
      prurl = "gh pr view --json url --jq .url";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git vi-mode"
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
      # set -g default-command "${pkgs.zsh}/bin/zsh"
      # set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      # for vim-gitgutter to work properly
      set -g focus-events on

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
      set -g visual-activity off
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
      font = {
        normal = {
          family = "Hack Nerd Font";
        };
      };
      colors = {
        # onedark
        # Default colors
        primary = {
          background = "#282c34";
          # background = "0x1e2127";
          foreground = "0xabb2bf";

          # Bright and dim foreground colors
          #
          # The dimmed foreground color is calculated automatically if it is not present.
          # If the bright foreground color is not set, or `draw_bold_text_with_bright_colors`
          # is `false`, the normal foreground color will be used.
          #dim_foreground = "0x9a9a9a";
          bright_foreground = "0xe6efff";
        };

        # Cursor colors
        #
        # Colors which should be used to draw the terminal cursor. If these are unset,
        # the cursor color will be the inverse of the cell color.
        #cursor =
        #  text = "0x000000";
        #  cursor = "0xffffff";

        # Normal colors
        normal = {
          black = "0x1e2127";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xd19a66";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0x828791";
        };
        # Bright colors
        bright = {
          black = "0x5c6370";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xd19a66";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0xe6efff";
        };
        # Dim colors
        #
        # If the dim colors are not set, they will be calculated automatically based
        # on the `normal` colors.
        dim = {
          black = "0x1e2127";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xd19a66";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0x828791";
        };
      };
      # colors = { # oh-lucy
      #   primary = {
      #     background = "#1B1D26";
      #     foreground = "#DED7D0";
      #   };
      #   normal = {
      #     black = "#938884";
      #     red = "#FF7DA3";
      #     green = "#7EC49D";
      #     yellow = "#EFD472";
      #     blue = "#8BB8D0";
      #     magenta = "#BDA9D4";
      #     cyan = "#BDA9D4";
      #     white = "#DED7D0";
      #   };
      #   bright = {
      #     black = "#938884";
      #     red = "#FF7DA3";
      #     green = "#7EC49D";
      #     yellow = "#EFD472";
      #     blue = "#8BB8D0";
      #     magenta = "#BDA9D4";
      #     cyan = "#BDA9D4";
      #     white = "#DED7D0";

      #   };
      # };
      # colors = {
      #   primary = {
      #     # background = "#1B1D26"; # oh-lucy
      #     background = "#282c34"; # onedark
      #     # background = "#303030";
      #   };
      # };
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

  programs.gpg = {
    enable = true;
  };

  home.file."${config.programs.gpg.homedir}/gpg-agent.conf".text = ''
    default-cache-ttl = 86400
  '';

}
