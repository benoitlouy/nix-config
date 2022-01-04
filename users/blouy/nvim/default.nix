{ pkgs, ... }:

let
  vimBaseConfig = builtins.readFile ./config.vim;
  vimPluginsConfig = builtins.readFile ./plugins.vim;
  cocConfig = builtins.readFile ./coc.vim;
  cocSettings = builtins.toJSON (import ./coc-settings.nix);
  vimConfig = vimBaseConfig + vimPluginsConfig + cocConfig;

  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;

  material-vim = buildVimPlugin {
    name = "material-vim";
    src = builtins.fetchTarball {
      name   = "material-vim-2020-10-21";
      url    = "https://github.com/kaicataldo/material.vim/archive/7a725ae.tar.gz";
      sha256 = "0nd3qvwpcbvawc6zaczzzyq0mxgfn7bfv36yw05f03rqipgfw6fn";
    };
  };

  new-plugins = pkgs.callPackage ./plugins.nix {
    inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    inherit (pkgs) fetchFromGitHub;
  };
in
{
  programs.neovim = {
    enable       = true;
    extraConfig  = vimConfig;
    plugins      = with pkgs.vimPlugins; [
      auto-pairs
      coc-nvim
      coc-metals
      # new-plugins.nvim-metals
      fzf-vim
      # lightline-vim
      material-vim
      multiple-cursors
      nerdtree
      nerdtree-git-plugin
      rainbow_parentheses-vim
      vim-airline
      vim-airline-themes
      vim-commentary
      vim-devicons
      vim-easy-align
      vim-easymotion
      vim-gitgutter
      vim-nix
      vim-scala
      vim-tmux-navigator
    ];
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;
    withNodeJs   = true; # for coc.nvim
    withPython3  = true; # for plugins
  };

  xdg.configFile = {
    "nvim/coc-settings.json".text = cocSettings;
  };
}
