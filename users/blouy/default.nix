userConf: hostConf: { config, pkgs, inputs, ... }:

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
  op-ssh-sign = if pkgs.stdenv.targetPlatform.isMacOS then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" else "${pkgs._1password-gui}/share/1password/op-ssh-sign";
in
{

  imports = [
    ./nvim
    ./tmux
  ];

  home.packages = with pkgs; [
    awscli2
    oh-my-zsh
    powerline-go
    fzf
    gnupg
    jdk8
    coursier
    tmux
    tmuxPlugins.power-theme
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    monaspace
    nixd
    nixpkgs-fmt
    nix-prefetch-git
    nodejs-slim
    tig
    ripgrep
    fd
    font-awesome
    yt-dlp
    terraform
    tree-sitter
    kubectl
    openconnect
    gnused
    terraform-ls
    jq
    yq
    ctop
    smithy-language-server
    # silicon
    yapf
    # black
    isort
    autoflake
    giter8
    ripgrep
    yt-dlp
    # smithytranslate
    jdt-language-server
    lazygit
    # git-machete
    diagnostic-languageserver
    nix-output-monitor
    mosh
    claude-code
  ] ++ addtlPackages;

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "vim";
    DIRENV_LOG_FORMAT = "";
    TERM = "xterm-256color";
    # SBT_NATIVE_CLIENT = "true";
  };

  programs.home-manager.enable = true;

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Benoit Louy";
        email = "${userConf.email}";
      };
      signing = {
        sign-all = true;
        backend = "ssh";
        key = "${userConf.sshkey}";
        backends.ssh.program = op-ssh-sign;
      };
    };
  };

  programs.git = {
    enable = true;
    signing = {
      key = if userConf.sign-with-ssh then "${userConf.sshkey}" else "${userConf.email}";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Benoit Louy";
        email = userConf.email;
      };
      pull.rebase = true;
      rerere.enabled = true;
      remote."origin".prune = true;
      merge.conflictstyle = "diff3";
    } // (if userConf.sign-with-ssh then {
      gpg.format = "ssh";
      gpg."ssh".program = op-ssh-sign;
    } else {});
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
      ".smithy.lsp.log"
    ];
  };

  programs.gh = {
    enable = true;
  };

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      verbs = [
        {
          invocation = "edit";
          shortcut = "e";
          key = "enter";
          apply_to = "text_file";
          execution = "$EDITOR +{line} {file}";
          leave_broot = false;
        }
        {
          key = "alt-right";
          execution = ":panel_right";
        }
        {
          key = "alt-left";
          execution = ":panel_left";
        }
      ];
    };
  };

  programs.zsh =
    let
      bindings = {
        "qwerty" = "";
        "colemak-dh" = ''
          # bindkey -M viins ii vi-cmd-mode
          bindkey -M vicmd m vi-insert
          bindkey -M vicmd j vi-add-next
          bindkey -M vicmd n vi-backward-char
          bindkey -M vicmd e down-line-or-history
          bindkey -M vicmd i up-line-or-history
          bindkey -M vicmd o vi-forward-char
          bindkey -M viins '^F' fzf-file-widget
          bindkey -M viins '^G' fzf-history-widget
        '';
      }."${config.keymap}";
    in
    {
      enable = true;
      initContent = ''
        export VI_MODE_SET_CURSOR=true
        export SHELL=${pkgs.zsh}/bin/zsh
        export EDITOR="vim"
        declare -a VPNDNS
        export VPNDNS=(
          "10.8.204.17"
          "192.168.1.1"
        )
        r () {
          cd "$(${pkgs.git}/bin/git rev-parse --show-toplevel 2>/dev/null)"
        }
        hh () {
          cd "''${1:-.}/$(find . -maxdepth 4 -name .git | sed 's|/.git$||' | ${pkgs.fzf}/bin/fzf --preview '${pkgs.tree}/bin/tree -L 2 ./{}')"
        }
        lfcd() {
          dir=$(${pkgs.lf}/bin/lf -print-last-dir "$@")
          while ! cd "$dir" 2> /dev/null
          do
            dir=$(dirname "$dir")
          done
        }
        gmd () {
          local remote="$1"
          if [[ -z "$remote" ]]; then
            remote=origin
          fi
          local branch=$(${pkgs.gh}/bin/gh repo view --json defaultBranchRef | ${pkgs.jq}/bin/jq -r .defaultBranchRef.name)
          ${pkgs.git}/bin/git fetch "$remote" "$branch"
          ${pkgs.git}/bin/git merge "$remote/$branch"
        }
        sdppr () {
          EXTRA_OPTS=()
          case "$GH_HOST" in
            github.bamtech.co)
              EXTRA_OPTS+=("--reviewer" "jbarber" "--reviewer" "agaro")
              ;;
            github.twdcgrid.net)
              EXTRA_OPTS+=("--reviewer" "jacob-barber" "--reviewer" "anthony-garo")
              ;;
            *)
              echo "$GH_HOST: unsupported github host" >&2
              return 1
              ;;
          esac
          ${pkgs.gh}/bin/gh pr create -f "''${EXTRA_OPTS[@]/#/}" "$@"
        }
      '' + bindings;
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
    modules = [
      "venv"
      "host"
      "ssh"
      "cwd"
      "perms"
      "git"
      "hg"
      "jobs"
      "exit"
      "root"
    ];
    modulesRight = [ "nix-shell" ];
    settings = {
      hostname-only-if-ssh = true;
    };
  };

  programs.eza = {
    enable = true;
  };

  programs.fzf.enable = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  programs.wezterm = {
    enable = false;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        shell = {
           program = "${pkgs.zsh}/bin/zsh";
        };
      };
      font = {
        normal = {
          family = "Hack Nerd Font";
          # family = "Monaspace Neon";
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

  programs.fastfetch = {
    enable = true;
    settings = {
      general = {
        preRun = "clear; echo '\n\n'";
      };
      logo = {
        padding = {
          top = 1;
          left = 1;
          right = 2;
        };
      };
      display = {
        separator = "  ";
      };
      modules = [
        # Title
        {
          type = "title";
          format = "{#1}╭────────────────────────────────╮";
          # format = "{#1}╭───────────── {#}{user-name-colored}";
        }
        # System Information
        {
          type = "custom";
          format = "{#1}│ {#}System Information";
        }
        {
          type = "os";
          key = "{#separator}│  {#keys}󰍹 OS";
        }
        {
          type = "kernel";
          key = "{#separator}│  {#keys}󰒋 Kernel";
        }
        {
          type = "uptime";
          key = "{#separator}│  {#keys}󰅐 Uptime";
        }
        {
          type = "packages";
          key = "{#separator}│  {#keys}󰏖 Packages";
          format = "{all}";
        }
        {
          type = "custom";
          format = "{#1}│";
        }
        # Desktop Environment
        {
          type = "custom";
          format = "{#1}│ {#}Desktop Environment";
        }
        {
          type = "de";
          key = "{#separator}│  {#keys}󰧨 DE";
        }
        {
          type = "wm";
          key = "{#separator}│  {#keys}󱂬 WM";
        }
        {
          type = "wmtheme";
          key = "{#separator}│  {#keys}󰉼 Theme";
        }
        {
          type = "display";
          key = "{#separator}│  {#keys}󰹑 Resolution";
        }
        {
          type = "shell";
          key = "{#separator}│  {#keys}󰞷 Shell";
        }
        {
          type = "terminalfont";
          key = "{#separator}│  {#keys}󰛖 Font";
        }
        {
          type = "custom";
          format = "{#1}│";
        }
        # Hardware Information
        {
          type = "custom";
          format = "{#1}│ {#}Hardware Information";
        }
        {
          key = "{#separator}│  {#keys}󰌢 Host";
          type = "host";
        }
        {
          type = "cpu";
          key = "{#separator}│  {#keys}󰻠 CPU";
        }
        {
          type = "gpu";
          key = "{#separator}│  {#keys}󰢮 GPU";
        }
        {
          type = "memory";
          key = "{#separator}│  {#keys}󰍛 Memory";
        }
        {
          type = "disk";
          key = "{#separator}│  {#keys}󰋊 Disk (/)";
          folders = "/";
        }
        {
          type = "custom";
          format = "{#1}│";
        }
        # Colors
        {
          type = "colors";
          key = "{#separator}│";
          symbol = "circle";
        }
        # Footer
        {
          type = "custom";
          format = "{#1}╰───────────────────────────────╯";
        }
      ];
    };
  };

  # xdg.mimeApps = let
  #   value = let
  #     zen-browser = config.programs.zen-browser.package;
  #   in
  #     zen-browser.meta.desktopFileName;
  #
  #   associations = builtins.listToAttrs (map (name: {
  #       inherit name value;
  #     }) [
  #       "application/x-extension-shtml"
  #       "application/x-extension-xhtml"
  #       "application/x-extension-html"
  #       "application/x-extension-xht"
  #       "application/x-extension-htm"
  #       "x-scheme-handler/unknown"
  #       "x-scheme-handler/mailto"
  #       "x-scheme-handler/chrome"
  #       "x-scheme-handler/about"
  #       "x-scheme-handler/https"
  #       "x-scheme-handler/http"
  #       "application/xhtml+xml"
  #       "application/json"
  #       "text/plain"
  #       "text/html"
  #     ]) // {
  #      "image/jpeg" = "imv.desktop";
  #     };
  # in {
  #   enable = !pkgs.stdenv.targetPlatform.isMacOS;
  #   associations.added = associations;
  #   defaultApplications = associations;
  # };

  # xdg.configFile = {
  #   "ghostty/config".text = ''
  #     # theme = Oxocarbon
  #     theme = Operator Mono Dark
  #     background-opacity = 0.8
  #     background-blur = true
  #     window-decoration = none
  #     font-size = ${toString config.term-font-size}
  #     font-family = ""
  #     font-family = "MonaspiceNe Nerd Font Mono"
  #     font-style = "Medium"
  #     font-thicken = true
  #   '';
  # };
}
