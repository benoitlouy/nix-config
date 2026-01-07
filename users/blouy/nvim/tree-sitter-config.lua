-- rainbow
-- enable rainbow parenthesis while using tree sitter for syntax highlighting
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "" })

require 'nvim-treesitter'.setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'smithy', 'scala', 'nix','lua', 'python', 'terraform' },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.opt.runtimepath:append("~/.config/nvim/site")

vim.lsp.config('smithy_ls', {
    cmd = { '@smithy-language-server@/bin/smithy-language-server', '-p', '0' },
})
vim.lsp.enable('smithy_ls')

vim.lsp.enable('terraformls')
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function() vim.lsp.buf.format({ async = false }) end,
})

vim.lsp.enable('nixd')

-- require'lspconfig'.pylsp.setup{
--   on_attach = on_attach,
--   settings = {
--     pylsp = {
--       plugins = {
--         -- black = {
--         --   enabled=true,
--         -- },
--         flake8 = {
--           enabled=true,
--           -- pyright overlap
--           ignore = {'F811', 'F401', 'F821', 'F841', 'E501', 'W503'},
--         },
--         pycodestyle = {
--           enabled=true,
--         },
--         autopep8 = {
--           enabled=false,
--         },
--         yapf = {
--           enabled=true,
--         },
--       },
--     },
--   },
-- }

vim.lsp.enable('pyright', {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        -- typeCheckingMode = 'basic',
        -- diagnosticSeverityOverrides = {
        --   reportConstantRedefinition = 'warning',
        --   reportDuplicateImport = 'warning',
        --   reportMissingSuperCall = 'warning',
        --   reportUnnecessaryCast = 'warning',
        --   reportUnnecessaryComparison = 'warning',
        --   reportUnnecessaryContains = 'warning',
        --   reportCallInDefaultInitializer = 'info',
        --   reportFunctionMemberAccess = 'info',
        --   reportImportCycles = 'info',
        --   reportMatchNotExhaustive = 'info',
        --   reportShadowedImports = 'info',
        --   reportUninitializedInstanceVariable = 'info',
        --   reportUnnecessaryIsInstance = 'info',
        --   reportUnusedClass = 'info',
        --   reportUnusedFunction = 'info',
        --   reportUnusedImport = 'info',
        --   reportUnusedVariable = 'info',
        -- },
      },
    },
  },
})

-- local diagnosticls = require("diagnosticls")
vim.lsp.enable('diagnosticls', {
  filetypes = { "python" },
  -- init_options = {
  --   filetypes = {
  --     python = {},
  --   },
  --   formatters = {
  --     black = {
  --       command = "black",
  --       args = {"--quiet", "-"},
  --       rootPatterns = {"pyproject.toml"},
  --     },
  --     isort = {
  --       command = "isort",
  --       args = { "--quiet", "-" },
  --       rootPatterns = { "pyproject.toml", ".isort.cfg" },
  --     },
  --   },
  --   formatFiletypes = {
  --     python = {"isort", "black"}
  --   }
  -- }
})

-- require 'lspconfig'.rust_analyzer.setup {}
vim.lsp.config('lua_ls', {
  cmd = { "@lualsp@/bin/lua-language-server" },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})
vim.lsp.enable('lua_ls')
