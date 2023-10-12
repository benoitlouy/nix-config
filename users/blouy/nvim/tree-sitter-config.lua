-- rainbow
-- enable rainbow parenthesis while using tree sitter for syntax highlighting
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "" })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.smithy" },
  callback = function() vim.cmd("setfiletype smithy") end
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.smithy = {
  filetype = "smithy" -- if filetype does not agrees with parser name
}

require'nvim-treesitter.configs'.setup {
  -- parser_install_dir = "~/.local/share/nvim/site",
  -- A list of parser names, or "all"
  -- ensure_installed = { "smithy" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['ii'] = '@conditional.inner',
        ['ai'] = '@conditional.outer',
        ['il'] = '@loop.inner',
        ['al'] = '@loop.outer',
        ['at'] = '@comment.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ['gl'] = '@function.outer',
        ['gy'] = '@class.outer',
      },
      goto_next_end = {
        ['gL'] = '@function.outer',
        ['gY'] = '@class.outer',
      },
      goto_previous_start = {
        ['gj'] = '@function.outer',
        ['gu'] = '@class.outer',
      },
      goto_previous_end = {
        ['gJ'] = '@function.outer',
        ['gU'] = '@class.outer',
      },
      -- goto_next = {
      --   [']i'] = "@conditional.inner",
      -- },
      -- goto_previous = {
      --   ['[i'] = "@conditional.inner",
      -- }
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

vim.opt.runtimepath:append("~/.config/nvim/site")

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
-- Check if the config is already defined (useful when reloading this file)
if not configs.smithy then
  configs.smithy = {
    default_config = {
      cmd = { 'smithy-language-server', '0' },
      filetypes = { 'smithy' },
      root_dir = util.root_pattern('smithy-build.json'),
      message_level = vim.lsp.protocol.MessageType.Log,
      init_options = {
        statusBarProvider = 'show-message',
        isHttpEnabled = true,
        compilerOptions = {
          snippetAutoIndent = false,
        },
      },
    }
  }
end
lspconfig.smithy.setup{}

require'lspconfig'.terraformls.setup{}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function() vim.lsp.buf.format({ async = false }) end,
})

require'lspconfig'.rnix.setup{}

require'lspconfig'.pylsp.setup{
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        -- black = {
        --   enabled=true,
        -- },
        flake8 = {
          enabled=true,
          -- pyright overlap
          ignore = {'F811', 'F401', 'F821', 'F841', 'E501', 'W503'},
        },
        pycodestyle = {
          enabled=true,
        },
        autopep8 = {
          enabled=false,
        },
        yapf = {
          enabled=true,
        },
      },
    },
  },
}

require'lspconfig'.pyright.setup{
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        diagnosticSeverityOverrides = {
          reportConstantRedefinition = 'warning',
          reportDuplicateImport = 'warning',
          reportMissingSuperCall = 'warning',
          reportUnnecessaryCast = 'warning',
          reportUnnecessaryComparison = 'warning',
          reportUnnecessaryContains = 'warning',
          reportCallInDefaultInitializer = 'info',
          reportFunctionMemberAccess = 'info',
          reportImportCycles = 'info',
          reportMatchNotExhaustive = 'info',
          reportShadowedImports = 'info',
          reportUninitializedInstanceVariable = 'info',
          reportUnnecessaryIsInstance = 'info',
          reportUnusedClass = 'info',
          reportUnusedFunction = 'info',
          reportUnusedImport = 'info',
          reportUnusedVariable = 'info',
        },
      },
    },
  },
}

require'lspconfig'.diagnosticls.setup{
  filetypes = {"python"},
  init_options = {
    filetypes = {
      python = {},
    },
    formatters = {
      black = {
        command = "black",
        args = {"--quiet", "-"},
        rootPatterns = {"pyproject.toml"},
      },
      isort = {
        command = "isort",
        args = { "--quiet", "-" },
        rootPatterns = { "pyproject.toml", ".isort.cfg" },
      },
    },
    formatFiletypes = {
      python = {"isort", "black"}
    }
  }
}

require'lspconfig'.rust_analyzer.setup{}

require'lspconfig'.lua_ls.setup {
  cmd = { "@lualsp@/bin/lua-language-server" },
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}
