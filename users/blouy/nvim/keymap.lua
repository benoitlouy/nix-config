vim.g.mapleader = ','


vim.keymap.set('n', '<C-n>', '<Nop>')

--- Colemak
-- Left, down, up, right
-- Note that 'g' is used for moving through wrapped line
vim.keymap.set({ 'n', 'x', 'o' }, 'n', 'h', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'e', 'gj', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'i', 'gk', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'o', 'l', { silent = true })

-- Insert and insert at beginning of line
vim.keymap.set('n', 't', 'i', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'T', 'I', { silent = true })

-- Next match, previous match
vim.keymap.set({ 'n', 'x', 'o' }, 'h', 'n', { silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'H', 'N', { silent = true })

-- Handy esc
vim.keymap.set('i', 'ii', '<Esc>', { silent = true })

-- resizing splits
vim.keymap.set('n', '<C-a>', require('smart-splits').resize_left)
vim.keymap.set('n', '<C-r>', require('smart-splits').resize_down)
vim.keymap.set('n', '<C-s>', require('smart-splits').resize_up)
vim.keymap.set('n', '<C-t>', require('smart-splits').resize_right)
-- moving between smart-splits
vim.keymap.set('n', '<M-Left>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<M-Down>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<M-Up>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<M-Right>', require('smart-splits').move_cursor_right)

vim.keymap.set('n', '<leader>R', require('smart-splits').start_resize_mode)
