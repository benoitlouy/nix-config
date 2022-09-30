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
}

vim.opt.runtimepath:append("~/.config/nvim/site")

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
-- Check if the config is already defined (useful when reloading this file)
if not configs.smithy then
  configs.smithy = {
    default_config = {
      cmd = { 'cs', 'launch', 'com.disneystreaming.smithy:smithy-language-server:latest.stable', '--' , '0' },
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
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = vim.lsp.buf.formatting_sync,
})
