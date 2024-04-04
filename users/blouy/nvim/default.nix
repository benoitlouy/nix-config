{ pkgs, config, ... }:

let
  vimBaseConfig = builtins.readFile ./config.vim;
  vimPluginsConfig = builtins.readFile ./plugins.vim;
  # nvimMetalsConfig = builtins.readFile ./nvim-metals-config.lua;
  nvimMetalsConfig = pkgs.substituteAll {
    src = ./nvim-metals-config.lua;
    metals = "${pkgs.metals}";
    jdtls = "${pkgs.jdt-language-server}";
    javaFormatter = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
    cacheHome = "${config.xdg.cacheHome}";
  };
  treeSitterConfig = pkgs.substituteAll {
    src = ./tree-sitter-config.lua;
    lualsp = "${pkgs.lua-language-server}";
  };
  vimConfig = ":lua require('keymap')\n" + vimBaseConfig + vimPluginsConfig + ''
    :lua require('nvim-metals-config')
  '';

  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;

  material-vim = buildVimPlugin {
    name = "material-vim";
    src = builtins.fetchTarball {
      name = "material-vim-2020-10-21";
      url = "https://github.com/kaicataldo/material.vim/archive/7a725ae.tar.gz";
      sha256 = "0nd3qvwpcbvawc6zaczzzyq0mxgfn7bfv36yw05f03rqipgfw6fn";
    };
  };

  new-plugins = pkgs.callPackage ./plugins.nix {
    inherit (pkgs.vimUtils) buildVimPlugin;
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

  googleJavaFormat = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
    sha256 = "14fz5fzzmp08qyhc94dvrkdy6wp0ai9df3k8bj6wizz3cyxj8mg7";
  };

  redhatJavaFormat = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/redhat-developer/vscode-java/master/formatters/eclipse-formatter.xml";
    sha256 = "06hgpbfmni5njiddlbcd1c1cd7nin5j52wpsm3jc9h9gzhn1wbbj";
  };
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
      pkgs.nodePackages.diagnostic-languageserver
      # pkgs.python311Packages.python-lsp-black
      # pkgs.python311Packages.black
      # pkgs.python311Packages.pyls-isort
      # pkgs.python311Packages.isort
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = toggleterm-nvim;

        config =
          let
            key = {
              "colemak-dh" = "<c-b>";
              "qwerty" = "<c-t>";
            }."${config.keymap}";
          in
          ''
            lua << EOF
            require("toggleterm").setup({
              open_mapping = [[${key}]],
              size = function(term)
                if term.direction == "horizontal" then
                  return 15
                elseif term.direction == "vertical" then
                  local col = vim.o.columns * 0.4
                  if col > 120 then
                    return 120
                  else
                    return col
                  end
                end
              end,
              direction = 'vertical'
            })
            EOF
          '';
      }
      {
        plugin = smart-splits-nvim;
        config =
          let
            content = {
              "colemak-dh" = builtins.readFile ./smart-splits-config-colemakdh.lua;
              "qwerty" = builtins.readFile ./smart-splits-config-qwerty.lua;
            }."${config.keymap}";
          in
          ''
            lua << EOF
            ${content}
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
        config =
          let
            ext = if pkgs.stdenv.isDarwin then "dylib" else "so";
          in
          "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.${ext}'";
      }
      # (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-scala
        tree-sitter-smithy
        tree-sitter-nix
        tree-sitter-hcl
        tree-sitter-python
        tree-sitter-lua
      ]))
      nvim-treesitter-textobjects
      playground
      nvim-lspconfig
      fzf-vim
      dracula-nvim
      lualine-nvim
      {
        plugin = multiple-cursors;
        config = "let g:multi_cursor_use_default_mapping=0";
      }
      nvim-tree-lua
      {
        plugin = mini-nvim;
        config =
          let
            setup =
              {
                "colemak-dh" = ''{
                  mappings = {
                    close       = 'q',
                    go_in       = 'o',
                    go_in_plus  = 'O',
                    go_out      = 'n',
                    go_out_plus = 'N',
                    reset       = '<BS>',
                    show_help   = 'g?',
                    synchronize = '=',
                    trim_left   = '<',
                    trim_right  = '>',
                  }
                }
                '';
                "qwerty" = "";
              }."${config.keymap}";
          in
          ''
            lua << EOF
            require('mini.files').setup(${setup})
            EOF
          '';
      }
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
      {
        plugin = comment-nvim;
        config = ''
          lua << EOF
          require('Comment').setup()
          local ft = require('Comment.ft')
          ft.smithy = '//%s'
          EOF
        '';
      }
      # vim-commentary
      vim-devicons
      # vim-easy-align
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
      diagnosticls-configs-nvim
      {
        plugin = lsp_signature-nvim;
        config = ''
          lua << EOF
          require "lsp_signature".setup({
            max_width = 160,
            handler_opts = {
              border = "rounded"
            },
            padding = ' '
          })
          EOF
        '';
      }
      {
        plugin = nvim-jdtls;
      }
      {
        plugin = hop-nvim;
        config = ''
          lua << EOF
          require('hop').setup({keys = 'arstgmneio'})
          EOF
        '';
      }
      {
        plugin = formatter-nvim;
        config = ''
          lua << EOF
          require'formatter'.setup{
            filetype = {
              java = {
                function()
                  local args
                  -- print(vim.api.nvim_get_mode().mode)
                  -- vim.print(vim.fn.getpos("v")[2])
                  -- vim.print(vim.fn.getpos(".")[2])
                  -- print(vim.fn.getpos("v")[2] .. ":" .. vim.fn.getpos(".")[2])
                  if vim.api.nvim_get_mode().mode == "v" then
                    args = {
                      '--lines',
                      vim.fn.getpos("v")[2] .. ":" .. vim.fn.getpos(".")[2],
                      vim.api.nvim_buf_get_name(0)
                    }
                  else
                    args = { vim.api.nvim_buf_get_name(0) }
                  end
                  -- vim.print(args)
                  return {
                    exe = '${pkgs.google-java-format}/bin/google-java-format',
                    args = args,
                    stdin = true
                  }
                end
              },
              ["*"] = {
                -- require("formatter.filetypes.any").remove_trailing_whitespace,
                function()
                  local defined_types = require("formatter.config").values.filetype
                  if defined_types[vim.bo.filetype] ~= nil then
                    return nil
                  end
                  if vim.api.nvim_get_mode().mode == "v" then
                    vim.lsp.buf.format({
                      range = {
                        ["start"] = vim.api.nvim_buf_get_mark(0, "v"),
                        ["end"] = vim.api.nvim_buf_get_mark(0, "."),
                      }
                    })
                  else
                    vim.lsp.buf.format({ async = true })
                  end
                end,
              },
            }
          }
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
    "nvim/lua/tree-sitter-config.lua".text = builtins.readFile "${treeSitterConfig}";
    "nvim/site/queries/smithy/highlights.scm".text = builtins.readFile "${pkgs.tree-sitter-grammars.tree-sitter-smithy.src}/queries/highlights.scm";
    "nvim/lua/keymap.lua".text = {
      "colemak-dh" = builtins.readFile ./keymap_colemakdh.lua;
      "qwerty" = builtins.readFile ./keymap_qwerty.lua;
    }."${config.keymap}";
  };

}
