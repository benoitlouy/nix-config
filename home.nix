{ config, pkgs, ... }:

let
  # vimBaseConfig = builtins.readFile ./config.vim;
  # vimPluginsConfig = builtins.readFile ./plugins.vim;
  # cocConfig = builtins.readFile ./coc.vim;
  # cocSettings = builtins.toJSON (import ./coc-settings.nix);
  # vimConfig = vimBaseConfig + vimPluginsConfig + cocConfig;

  # buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;

  # material-vim = buildVimPlugin {
  #   name = "material-vim";
  #   src = builtins.fetchTarball {
  #     name   = "material-vim-2020-10-21";
  #     url    = "https://github.com/kaicataldo/material.vim/archive/7a725ae.tar.gz";
  #     sha256 = "0nd3qvwpcbvawc6zaczzzyq0mxgfn7bfv36yw05f03rqipgfw6fn";
  #   };
  # };

in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "blouy";
  home.homeDirectory = "/Users/blouy";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    (import ./nvim)
  ];

  home.packages = with pkgs; [
    oh-my-zsh
    direnv
    nix-direnv
    powerline-go
    powerline
    fzf
    gnupg
    yabai
    adoptopenjdk-hotspot-bin-8
    tmux
    tmuxPlugins.power-theme
    reattach-to-user-namespace
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
    rnix-lsp
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = "vim";
    DIRENV_LOG_FORMAT = "";
    SBT_NATIVE_CLIENT = "true";
  };

  programs.bash.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.adoptopenjdk-hotspot-bin-8;
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

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
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
      bind H resize-pane -L 5
      bind J resize-pane -D 5
      bind K resize-pane -U 5
      bind L resize-pane -R 5

      # clear history
      bind C-l send-keys C-l
      bind C-k send-keys -R \; send-keys C-l \; clear-history

      run-shell "powerline-daemon -q"
      source "${pkgs.powerline}/share/tmux/powerline.conf"
      # set -g @tmux_power_theme '#585858'
      # run-shell "${pkgs.tmuxPlugins.power-theme}/share/tmux-plugins/power/tmux-power.tmux"

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

  programs.direnv.enable = true;
  # programs.direnv.nix-direnv.enable = true;
  programs.direnv.stdlib = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
    use nix
  '';
  # optional for nix flakes support
  # programs.direnv.nix-direnv.enableFlakes = true;

  programs.fzf.enable = true;

  # programs.neovim = {
  #   enable       = true;
  #   extraConfig  = vimConfig;
  #   plugins      = with pkgs.vimPlugins; [
  #     auto-pairs
  #     coc-nvim
  #     coc-metals
  #     fzf-vim
  #     # lightline-vim
  #     material-vim
  #     multiple-cursors
  #     nerdtree
  #     nerdtree-git-plugin
  #     rainbow_parentheses-vim
  #     vim-airline
  #     vim-airline-themes
  #     vim-commentary
  #     vim-devicons
  #     vim-easy-align
  #     vim-easymotion
  #     vim-gitgutter
  #     vim-nix
  #     vim-scala
  #     vim-tmux-navigator
  #   ];
  #   viAlias      = true;
  #   vimAlias     = true;
  #   vimdiffAlias = true;
  #   withNodeJs   = true; # for coc.nvim
  #   withPython3  = true; # for plugins
  # };

  # xdg.configFile = {
  #   "nvim/coc-settings.json".text = cocSettings;
  # };
}
