-- idea of what everything does. Again, these are meant to serve as an example,
-- if you just copy pasta them, then they'll work,  but hopefully after time
-- goes on you'll cater them to your own liking.
--
-- The below configuration also makes use of the following plugins besides
-- nvim-metals, and therefore is a bit opinionated:
--
-- - https://github.com/hrsh7th/nvim-cmpe
--   - hrsh7th/cmp-nvim-lsp for lsp completion sources
--   - hrsh7th/cmp-vsnip for snippet sources
--   - hrsh7th/vim-vsnip for snippet support
--
-- - https://github.com/wbthomason/packer.nvim for package management
-- - https://github.com/mfussenegger/nvim-dap (for debugging)
-------------------------------------------------------------------------------
local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------------------------
-- PLUGINS -----------------------
----------------------------------
-- cmd([[packadd packer.nvim]])
-- require("packer").startup(function(use)
--   use({ "wbthomason/packer.nvim", opt = true })

--   use({
--     "hrsh7th/nvim-cmp",
--     requires = {
--       { "hrsh7th/cmp-nvim-lsp" },
--       { "hrsh7th/cmp-vsnip" },
--       { "hrsh7th/vim-vsnip" },
--     },
--   })
--   use({
--     "scalameta/nvim-metals",
--     requires = {
--       "nvim-lua/plenary.nvim",
--       "mfussenegger/nvim-dap",
--     },
--   })
-- end)

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
vim.opt_global.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt_global.completeopt = { "menu", "noinsert", "noselect" }
-- vim.opt_global.shortmess:remove("F"):append("c")

-- LSP
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gbs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

-- completion related settings
-- This is similiar to what I use
local cmp = require("cmp")
cmp.setup({
  completion = { completeopt = "noselect" },
  preselect = cmp.PreselectMode.None,
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = "nvim_lsp_document_symbol" },
    -- { name = "nvim_lsp_signature_help" },
    { name = "rg" },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  -- sources = {
  --   { name = "nvim_lsp" },
  --   { name = "vsnip" },
  --   { name = "buffer" }
  -- },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      -- require("cmp-under-comparator").under,
      cmp.config.compare.kind,
    },
  },
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- None of this made sense to me when first looking into this since there
    -- is no vim docs, but you can't have select = true here _unless_ you are
    -- also using the snippet stuff. So keep in mind that if you remove
    -- snippets you need to remove this select
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- I use tabs... some say you should stick to ins-completion
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
})

----------------------------------
-- COMMANDS ------------------
----------------------------------
-- LSP
-- cmd([[augroup lsp]])
-- cmd([[autocmd!]])
-- cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
-- -- NOTE: You may or may not want java included here. You will need it if you want basic Java support
-- -- but it may also conflict if you are using something like nvim-jdtls which also works on a java filetype
-- -- autocmd.
-- cmd([[autocmd FileType java,scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
-- cmd([[augroup end]])

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

----------------------------------
-- LSP Setup ---------------------
----------------------------------
metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
  showImplicitConversionsAndClasses = true,
  metalsBinaryPath = "@metals@/bin/metals",
  testUserInterface = "Test Explorer",
  --   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  --   serverVersion = "0.10.9+133-9aae968a-SNAPSHOT",
}
metals_config.settings["javaFormat.eclipseConfigPath"] = "@javaFormatter@"
metals_config.settings["javaFormat.eclipseProfile"] = "GoogleStyle"

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- If you want a :Format command this is useful
cmd([[command! Format lua vim.lsp.buf.format { async = true }]])

local function metals_status()
  return vim.g["metals_status"] or ""
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { metals_status, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
}

require("nvim-tree").setup({
  view = {
    adaptive_size = false
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true
  }
})

map("n", "<leader>tt", [[<cmd>NvimTreeToggle<CR>]])
map("n", "<leader>tf", [[<cmd>NvimTreeFocus<CR>]])
map("n", "<leader>tc", [[<cmd>NvimTreeCollapse<CR>]])
map("n", "<leader>tF", [[<cmd>NvimTreeFindFile<CR>]])
