vim.g.mapleader = "\t"


vim.keymap.set('n', '<C-n>', '<Nop>')

--- Colemak
-- Left, down, up, right
-- Note that 'g' is used for moving through wrapped line
vim.keymap.set({ 'n', 'x', 'o' }, 'n', 'h', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'e', 'gj', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'i', 'gk', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'o', 'l', { silent = true })

vim.keymap.set('n', 'j', 'a', { silent = true })
vim.keymap.set('n', 'J', 'A', { silent = true })
vim.keymap.set('n', 'l', 'o', { silent = true })
vim.keymap.set('n', 'L', 'O', { silent = true })
-- Insert and insert at beginning of line
vim.keymap.set('n', 'm', 'i', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'M', 'I', { silent = true })

-- Next match, previous match
vim.keymap.set({ 'n', 'x', 'o' }, 'h', 'n', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'H', 'N', { silent = true })

-- Handy esc
vim.keymap.set('i', 'ii', '<Esc>', { silent = true })

vim.keymap.set('n', '<C-l>', '<C-o>', { silent = true })

-- resizing splits
vim.keymap.set('n', '<C-a>', require('smart-splits').resize_left)
vim.keymap.set('n', '<C-r>', require('smart-splits').resize_down)
vim.keymap.set('n', '<C-s>', require('smart-splits').resize_up)
vim.keymap.set('n', '<C-t>', require('smart-splits').resize_right)
-- moving between smart-splits
vim.keymap.set('n', '<C-n>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-e>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-i>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-o>', require('smart-splits').move_cursor_right)

vim.keymap.set('n', '<leader>R', require('smart-splits').start_resize_mode)

local ts_builtin = require('telescope.builtin')
local ts_theme = require('telescope.themes')
vim.keymap.set('n', '<leader>ff', ts_builtin.find_files)
vim.keymap.set('n', '<leader>fg', ts_builtin.live_grep)
vim.keymap.set('n', '<leader>fb', ts_builtin.buffers)
vim.keymap.set('n', '<leader>fh', ts_builtin.help_tags)
vim.keymap.set('n', '<leader>fs', function () ts_builtin.lsp_document_symbols({ ignore_symbols = {'variable', 'constant'}}) end)
vim.keymap.set('n', '<leader>fa', function () ts_builtin.diagnostics({ bufnr = 0, layout_strategy = 'vertical' }) end)

vim.keymap.set('n', '<leader>fm', function () require('telescope').extensions.metals.commands() end)

vim.keymap.set('n', '<leader>clr', vim.lsp.codelens.run)

vim.keymap.set('n', '<leader><CR>', ':vsplit<CR>', { silent = true })
vim.keymap.set('n', '<leader><BS>', ':split<CR>', { silent = true })
