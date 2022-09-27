local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cs', 'launch', 'com.disneystreaming.smithy:smithy-language-server:0.0.10', '--' , '0' },
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
  },
  docs = {
    description = [[
    Wake and bake, slumming it bruh
]],
    default_config = {
      root_dir = [[util.root_pattern("smithy-build.json")]],
    },
  },
}
