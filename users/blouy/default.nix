userConf: hostConf: { config, pkgs, ... }:

let
  workPackages = with pkgs; [
    devx
    vpn
  ];
  darwinPackages = with pkgs; [
    reattach-to-user-namespace
    chatty-twitch
  ];
  addtlPackages = (if hostConf.isWork then workPackages else [ ]) ++ (if pkgs.stdenv.isDarwin then darwinPackages else [ ]);
in
{

  imports = [
    ./nvim
    ./tmux
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
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
    rnix-lsp
    nix-prefetch-git
    nodejs-slim
    tig
    ripgrep
    fd
    font-awesome
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
    yapf
    # black
    isort
    autoflake
    giter8
    ripgrep
    # smithytranslate
  ] ++ addtlPackages;

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "vim";
    DIRENV_LOG_FORMAT = "";
    TERM = "xterm-256color";
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

  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf.enable = true;

  programs.bat.enable = true;

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
      key_bindings = [
        # send the tab key code prefixed with F12 to tell tmux to enter the virtual key-table
        { key = "I"; mods = "Control"; chars = "\\x1b[24~\\x09"; }
      ];
    };
  };

  programs.awscli = {
    package = pkgs.awscli2;
    enable = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;
  };

  programs.awsvault = {
    enable = true;
    prompt = "ykman";
    backend = "keychain";
    passPrefix = "aws_vault/";
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      quality-menu
    ];
    config =
      (if pkgs.stdenv.isLinux then {
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
        gpu-context = "wayland";
        no-border = "";
      } else {
        no-border = "";
      });
  };

  programs.gpg = {
    enable = true;
  };

}
