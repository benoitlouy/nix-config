vim.g.mapleader = "\t"


vim.keymap.set('n', '<C-n>', '<Nop>')

--- Colemak
-- Left, down, up, right
-- Note that 'g' is used for moving through wrapped line
vim.keymap.set({ 'n', 'x', 'o' }, 'n', 'h', { silent = true, desc = "Move left" })
vim.keymap.set({ 'n', 'x', 'o' }, 'e', 'gj', { silent = true, desc = "Move down" })
vim.keymap.set({ 'n', 'x', 'o' }, 'i', 'gk', { silent = true, desc = "Move up"})
vim.keymap.set({ 'n', 'x', 'o' }, 'o', 'l', { silent = true, desc = "Move right" })

vim.keymap.set('n', 'j', 'a', { silent = true })
vim.keymap.set('n', 'J', 'A', { silent = true })
vim.keymap.set('n', 'l', 'o', { silent = true })
vim.keymap.set('n', 'L', 'O', { silent = true })
-- Insert and insert at beginning of line
vim.keymap.set('n', 'm', 'i', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'M', 'I', { silent = true })

-- Next match, previous match
vim.keymap.set({ 'n', 'x', 'o' }, 'h', 'n', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'k', 'N', { silent = true })

-- Next error, previous error
vim.keymap.set('n', '<leader>h', function() vim.diagnostic.goto_next({ wrap = false }) end)
vim.keymap.set('n', '<leader>k', function() vim.diagnostic.goto_prev({ wrap = false }) end)

-- Handy esc
vim.keymap.set('i', 'ii', '<Esc>', { silent = true })

vim.keymap.set('n', '<C-l>', '<C-o>', { silent = true })

-- resizing splits
vim.keymap.set('n', '<C-a>', require('smart-splits').resize_left)
vim.keymap.set('n', '<C-r>', require('smart-splits').resize_down)
vim.keymap.set('n', '<C-s>', require('smart-splits').resize_up)
vim.keymap.set('n', '<C-t>', require('smart-splits').resize_right)
-- moving between smart-splits
vim.keymap.set({ 'n', 't' }, '<C-n>', require('smart-splits').move_cursor_left)
vim.keymap.set({ 'n', 't' }, '<C-e>', require('smart-splits').move_cursor_down)
vim.keymap.set({ 'n', 't' }, '<C-i>', require('smart-splits').move_cursor_up)
vim.keymap.set({ 'n', 't' }, '<C-o>', require('smart-splits').move_cursor_right)

vim.keymap.set('n', '<leader>R', require('smart-splits').start_resize_mode)

local ts_builtin = require('telescope.builtin')
local ts_theme = require('telescope.themes')
vim.keymap.set('n', '<leader>ff', ts_builtin.find_files)
vim.keymap.set('n', '<leader>fg', ts_builtin.live_grep)
vim.keymap.set('n', '<leader>fb', ts_builtin.buffers)
vim.keymap.set('n', '<leader>fh', ts_builtin.help_tags)
vim.keymap.set('n', '<leader>fs', function () ts_builtin.lsp_document_symbols({ ignore_symbols = {'variable', 'constant'}}) end)
vim.keymap.set('n', '<leader>fa', function () ts_builtin.diagnostics({ bufnr = 0, layout_strategy = 'vertical' }) end)
vim.keymap.set('n', '<leader>fA', function () ts_builtin.diagnostics({ layout_strategy = 'vertical' }) end)
vim.keymap.set('n', 'gd', ts_builtin.lsp_definitions)
vim.keymap.set('n', 'gi', ts_builtin.lsp_implementations)
vim.keymap.set('n', 'gr', ts_builtin.lsp_references)
-- vim.keymap.set('n', 'gr', ts_builtin.lsp_document_symbols)

vim.keymap.set('n', '<leader>fm', function () require('telescope').extensions.metals.commands() end)

vim.keymap.set('n', '<leader>ft', function () vim.lsp.buf.format { async = true } end)

vim.keymap.set('n', '<leader>clr', vim.lsp.codelens.run)

vim.keymap.set('n', '<leader><CR>', ':vsplit<CR>', { silent = true })
vim.keymap.set('n', '<leader><BS>', ':split<CR>', { silent = true })

vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = 0 })

if vim.lsp.inlay_hint then
  vim.keymap.set('n', "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle inlay hints" })
end
