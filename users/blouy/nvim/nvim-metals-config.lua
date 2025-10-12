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

    local buildFile = vim.fs.find({'build.sbt', 'build.sc', 'bleep.yaml'}, {
      upward = true,
      stop = vim.env.HOME,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })

    local tokens = vim.split(vim.api.nvim_buf_get_name(0), "[.]")
    local ext = tokens[#tokens]

    if #buildFile > 0 or ext == "sc" then
      require("metals").initialize_or_attach(metals_config)
    end
  end,
  group = nvim_metals_group,
})

local jdtls_group = vim.api.nvim_create_augroup("jdtls", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java" },
  callback = function()
    local project_name = vim.fn.getcwd()
    local workspace_dir = '@cacheHome@/jdtls' .. project_name
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local config = {
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities),
        cmd = {'@jdtls@/bin/jdtls',  '-data', workspace_dir},
        -- ['java.format.settings.url'] = "@javaFormatter@",
        -- ['java.format.settings.profile'] = "GoogleStyle",
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = 'fernflower' },
          format = {
              enabled = false,
              settings = {
                url = '@javaFormatter@2',
                profile = 'SomeStyle',
              }
            }
        },
        on_init = function(client)
          if client.config.settings then
            client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})
          end
        end,
        root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml'}, { upward = true })[1]),
    }

    local buildFile = vim.fs.find({'pom.xml'}, {
      upward = true,
      stop = vim.env.HOME,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })

    if #buildFile > 0 then
      require('jdtls').start_or_attach(config)
    end
  end,
  group = jdtls_group,
})


----------------------------------
-- LSP Setup ---------------------
----------------------------------
metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  serverProperties = {'-Xmx4g'},
  showImplicitArguments = true,
  showInferredType = true,
  showImplicitConversionsAndClasses = true,
  metalsBinaryPath = "@metals@/bin/metals",
  testUserInterface = "Test Explorer",
  superMethodLensesEnabled = true,
  useGlobalExecutable = false,
  enableBestEffort = true,
  enableStripMarginOnTypeFormatting = true,
  inlayHints = {
    byNameParameters = { enable = true },
    hintsInPatternMatch = { enable = true },
    implicitArguments = { enable = true },
    implicitConversions = { enable = true },
    inferredTypes = { enable = true },
    typeParameters = { enable = true },
  },
  showImplicitArguments = true,
  --   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  --   serverVersion = "0.10.9+133-9aae968a-SNAPSHOT",
}
metals_config.settings["javaFormat.eclipseConfigPath"] = "@javaFormatter@"
-- metals_config.settings["javaFormat.eclipseProfile"] = "GoogleStyle"

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
metals_config.init_options.statusBarProvider = "off"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

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
-- cmd([[command! Format lua vim.lsp.buf.format { async = true }]])

require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'tokyonight',
    -- theme = 'onedark',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
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
