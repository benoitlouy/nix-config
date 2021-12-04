{ config, pkgs, ... }:

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

  home.packages = with pkgs; [
    oh-my-zsh
    direnv
    nix-direnv
    powerline-go
    fzf
    gnupg
    yabai
    adoptopenjdk-hotspot-bin-8
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

}
