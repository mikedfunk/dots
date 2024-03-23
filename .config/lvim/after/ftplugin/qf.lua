vim.cmd 'wincmd J'

vim.keymap.set('n', 's', '<C-w><Enter>', { noremap = true, buffer = true, desc = 'Split Horizontally' })
vim.keymap.set('n', 'v', '<C-w><Enter><C-w>L', { noremap = true, buffer = true, desc = 'Split Vertically' })
vim.keymap.set('n', 't', '<C-w><Enter><C-w>T', { noremap = true, buffer = true, desc = 'Open in Tab' })
