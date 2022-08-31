{ pkgs, ... }:

let
  use-nvim-metals = true;

  vimBaseConfig = builtins.readFile ./config.vim;
  vimPluginsConfig = builtins.readFile ./plugins.vim;
  cocConfig = builtins.readFile ./coc-mappings.vim;
  nvimMetalsConfig = builtins.readFile ./nvim-metals-config.lua;
  cocSettings = builtins.toJSON (import ./coc-settings.nix);

  vimConfig = vimBaseConfig + vimPluginsConfig + (if use-nvim-metals then ":lua require('nvim-metals-config')\n" else cocConfig);

  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;

  material-vim = buildVimPlugin {
    name = "material-vim";
    src = builtins.fetchTarball {
      name = "material-vim-2020-10-21";
      url = "https://github.com/kaicataldo/material.vim/archive/7a725ae.tar.gz";
      sha256 = "0nd3qvwpcbvawc6zaczzzyq0mxgfn7bfv36yw05f03rqipgfw6fn";
    };
  };

  new-plugins = pkgs.callPackage ./plugins.nix {
    inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    inherit (pkgs) fetchFromGitHub;
  };

  nvim-metals-plugins = with pkgs.vimPlugins; [
    nvim-metals
    nvim-cmp
    cmp-nvim-lsp
    cmp-vsnip
    cmp-buffer
    vim-vsnip
    nvim-dap
    nvim-bqf
  ];

  coc-metals-plugins = with pkgs; [
    vimPlugins.coc-nvim
    vimPlugins.coc-metals
    vimPlugins.telescope-coc-nvim
  ];


in
{
  programs.neovim = {
    enable = true;
    extraConfig = vimConfig;
    plugins = with pkgs.vimPlugins; [
      auto-pairs
      plenary-nvim
      telescope-nvim
      nvim-neoclip-lua
      {
        plugin = sqlite-lua;
        config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.dylib'";
      }
      (nvim-treesitter.withPlugins (plugins: [
        pkgs.tree-sitter-grammars.tree-sitter-scala
        pkgs.tree-sitter-smithy
      ]))
      fzf-vim
      lualine-nvim
      material-vim
      multiple-cursors
      nerdtree
      nerdtree-git-plugin
      rainbow
      vim-monokai-pro
      onedark-vim
      sonokai
      vim-commentary
      vim-devicons
      vim-easy-align
      vim-easymotion
      vim-gitgutter
      vim-nix
      vim-scala
      vim-tmux-navigator
      vim-fugitive
      vim-startify
      markdown-preview-nvim
    ] ++ (if use-nvim-metals then nvim-metals-plugins else coc-metals-plugins);
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
  };

  xdg.configFile = {
    "nvim/coc-settings.json".text = cocSettings;
    "nvim/lua/nvim-metals-config.lua".text = nvimMetalsConfig;
    "nvim/lua/tree-sitter-config.lua".text = builtins.readFile ./tree-sitter-config.lua;
  };
}
