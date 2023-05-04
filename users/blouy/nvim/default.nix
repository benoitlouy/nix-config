{ pkgs, ... }:

let
  vimBaseConfig = builtins.readFile ./config.vim;
  vimPluginsConfig = builtins.readFile ./plugins.vim;
  # nvimMetalsConfig = builtins.readFile ./nvim-metals-config.lua;
  nvimMetalsConfig = pkgs.substituteAll {
    src = ./nvim-metals-config.lua;
    metals = "${pkgs.metals}";
  };
  vimConfig = vimBaseConfig + vimPluginsConfig + ":lua require('nvim-metals-config')\n";

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
    cmp-rg
    cmp-path
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp
    cmp-vsnip
    cmp-buffer
    vim-vsnip
    nvim-dap
    nvim-bqf
  ];

in
{
  programs.neovim = {
    enable = true;
    extraConfig = vimConfig;
    extraPackages = [
      pkgs.nodePackages.pyright
      pkgs.python311Packages.python-lsp-server
      pkgs.python311Packages.flake8
      pkgs.python311Packages.pycodestyle
      pkgs.python311Packages.autopep8
      pkgs.python311Packages.yapf
      # pkgs.python311Packages.python-lsp-black
      # pkgs.python311Packages.black
      # pkgs.python311Packages.pyls-isort
      # pkgs.python311Packages.isort
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = new-plugins.bufterm;
        config = ''
          lua << EOF
          ${builtins.readFile ./bufterm-config.lua}
          EOF
        '';

      }
      {
        plugin = smart-splits-nvim;
        config = ''
          lua << EOF
          ${builtins.readFile ./smart-splits-config.lua}
          EOF
        '';
      }
      auto-pairs
      plenary-nvim
      {
        plugin = telescope-nvim;
        config = ''
          lua << EOF
          ${builtins.readFile ./telescope-config.lua}
          EOF
        '';
      }
      telescope-ui-select-nvim
      nvim-neoclip-lua
      {
        plugin = sqlite-lua;
        config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.dylib'";
      }
      # (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-scala
        tree-sitter-smithy
        tree-sitter-nix
        tree-sitter-hcl
        tree-sitter-python
      ]))
      playground
      nvim-lspconfig
      fzf-vim
      dracula-nvim
      lualine-nvim
      multiple-cursors
      nvim-tree-lua
      nvim-web-devicons
      rainbow
      nightfox-nvim
      {
        plugin = onedark-nvim;
        config = ''
          lua << EOF
          require('onedark').setup {
            -- style = 'warm'
          }
          require('onedark').load()
          EOF
        '';
      }
      vim-commentary
      vim-devicons
      vim-easy-align
      vim-easymotion
      {
        plugin = gitsigns-nvim;
        config = ''
          lua << EOF
          require('gitsigns').setup()
          EOF
        '';
      }
      vim-nix
      vim-scala
      vim-fugitive
      vim-startify
      markdown-preview-nvim
      {
        plugin = silicon-lua;
        config = ''
          lua << EOF
          ${builtins.readFile ./silicon-lua-config.lua}
          EOF
        '';
      }
      nvim-navic
      kanagawa-nvim
      lsp-status-nvim
      {
        plugin = nvim-surround;
        config = ''
          lua << EOF
          require("nvim-surround").setup({
          })
          EOF
        '';
      }
      # {
      #   plugin = tabline-nvim;
      #   config = ''
      #     lua << EOF
      #     require('tabline').setup()
      #     EOF
      #   '';
      # }
      # {
      #   plugin = bufferline-nvim;
      #   config = ''
      #     lua << EOF
      #     require('bufferline').setup()
      #     EOF
      #   '';
      # }
      {
        plugin = symbols-outline-nvim;
        config = ''
          lua << EOF
          require("symbols-outline").setup()
          EOF
        '';
      }
    ] ++ nvim-metals-plugins;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
  };

  xdg.configFile = {
    "nvim/lua/nvim-metals-config.lua".text = builtins.readFile "${nvimMetalsConfig}";
    "nvim/lua/tree-sitter-config.lua".text = builtins.readFile ./tree-sitter-config.lua;
    "nvim/site/queries/smithy/highlights.scm".text = builtins.readFile "${pkgs.tree-sitter-grammars.tree-sitter-smithy.src}/queries/highlights.scm";
  };

}
