{ pkgs, config, ... }:

let
  vimBaseConfig = builtins.readFile ./config.vim;
  vimPluginsConfig = builtins.readFile ./plugins.vim;
  nvimMetalsConfig = pkgs.replaceVars ./nvim-metals-config.lua {
    metals = "${pkgs.metals}";
    jdtls = "${pkgs.jdt-language-server}";
    javaFormatter = googleJavaFormat;
    cacheHome = "${config.xdg.cacheHome}";
  };
  treeSitterConfig = pkgs.replaceVars ./tree-sitter-config.lua {
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

  toggleterm-manager-nvim = buildVimPlugin {
    name = "toggleterm-manager.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ryanmsnyder";
      repo = "toggleterm-manager.nvim";
      rev = "v1.0.1";
      hash = "sha256-7t61kcqeOS9hPXc9y88Sa8D0ZXIqxCXtxFQzmHKFJ8c=";
    };
    dependencies = [ pkgs.vimPlugins.telescope-nvim pkgs.vimPlugins.plenary-nvim pkgs.vimPlugins.toggleterm-nvim ];
  };

  new-plugins = pkgs.callPackage ./plugins.nix {
    inherit (pkgs.vimUtils) buildVimPlugin;
    inherit (pkgs) fetchFromGitHub;
  };

  nvim-metals-plugins = with pkgs.vimPlugins; [
    nvim-metals
    {
      plugin = blink-cmp;
      config = ''
        lua << EOF
        require('blink-cmp').setup({
          keymap = {
            preset = 'default',
            ['<Tab>'] = { 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<CR>'] = { 'select_and_accept', 'fallback' },
          },
          sources = {
            default = { 'lsp', 'copilot', 'buffer', 'snippets', 'path' },
            providers = {
              copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 100,
                async = true,
                opts = {
                  max_completions = 3,
                },
              },
            },
          },
          completion = {
            ghost_text = {
              enabled = true,
            },
            documentation = {
              auto_show = true,
            },
            accept = {
              auto_brackets = { enabled = false },
            },
          },
          signature = {
            enabled = true,
            window = {
              show_documentation = true,
            },
          },
          fuzzy = {
            implementation = "prefer_rust_with_warning" ,
          },
        })
        EOF
      '';
    }
    blink-copilot
    {
      plugin = CopilotChat-nvim;
      config = ''
        lua << EOF
        require("CopilotChat").setup({
        })
        EOF
      '';
    }
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
      pkgs.pyright
      pkgs.python311Packages.flake8
      pkgs.python311Packages.pycodestyle
      pkgs.python311Packages.autopep8
      pkgs.python311Packages.yapf
      pkgs.nodePackages.diagnostic-languageserver
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
      # auto-pairs
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
      {
        plugin = outline-nvim;
        config = ''
          lua << EOF
          require("outline").setup({})
          EOF
        '';
      }
      diagnosticls-configs-nvim
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
      {
        plugin = toggleterm-manager-nvim;
        config = ''
          lua << EOF
          require("toggleterm-manager").setup {
            titles = {
              prompt = "Pick Term",
              results = "Terminals"
            },
            -- more overrides if desired
          }
          EOF
        '';
      }
      {
        plugin = guess-indent-nvim;
        config = ''
          lua << EOF
          require('guess-indent').setup {}
          EOF
        '';
      }
      {
        plugin = fidget-nvim;
        config = ''
          lua << EOF
          require("fidget").setup {
          }
          EOF
        '';
      }
      {
        plugin = tiny-inline-diagnostic-nvim;
        config = ''
          lua << EOF
          require('tiny-inline-diagnostic').setup({
            options = {
              multilines = {
                enabled = true,
                always_show = true,
              },
            },
          })
          EOF
        '';
      }
      {
        plugin = blink-pairs;
        config = ''
          lua << EOF
          require('blink-pairs').setup({
            highlights = {
              enabled = true,
            },
          })
          EOF
        '';
      }
      rustaceanvim
      {
        plugin = copilot-lua;
        config = ''
          lua << EOF
          require("copilot").setup({})
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
