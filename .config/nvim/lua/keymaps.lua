vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('i', '<C-c>', '<ESC>', { noremap = true })

vim.keymap.set('c', '<C-p>', '<Up>', { noremap = true })
vim.keymap.set('c', '<Up>', '<C-p>', { noremap = true })
vim.keymap.set('c', '<C-n>', '<Down>', { noremap = true })
vim.keymap.set('c', '<Down>', '<C-n>', { noremap = true })

vim.keymap.set('n', '<ESC><ESC>', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-c><C-c>', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>sb', ':%s/<C-r><C-w>//g<Left><Left>', { noremap = true })
vim.keymap.set('v', '<Leader>sb', [["xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<cr>//g<Left><Left>]], { noremap = true })

vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

vim.keymap.set('n', '0', '^', { noremap = true })
-- vim.keymap.set('n', '9', '$', { noremap = true })

vim.keymap.set('n', '<Space>j', '<C-f>', { noremap = true })
vim.keymap.set('n', '<Space>k', '<C-b>', { noremap = true })

vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })

vim.keymap.set('n', 'tc', ':<C-u>tabnew<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'tx', ':<C-u>tabclose<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'to', ':<C-u>tabonly<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space><Space>', ':<C-u>tabnext<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<BS><BS>', ':<C-u>tabprevious<cr>', { noremap = true, silent = true })

vim.keymap.set('i', '<C-e>', '<END>', { noremap = true })
vim.keymap.set('i', '<C-a>', '<HOME>', { noremap = true })
vim.keymap.set('i', '<C-j>', '<Down>', { noremap = true })
vim.keymap.set('i', '<C-k>', '<Up>', { noremap = true })
vim.keymap.set('i', '<C-h>', '<Left>', { noremap = true })
vim.keymap.set('i', '<C-l>', '<Right>', { noremap = true })

vim.keymap.set('v', 'v', '$h', { noremap = true })
vim.keymap.set('v', '1', '^', { noremap = true })

vim.keymap.set('i', ',', ',<Space>', { noremap = true })
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', { noremap = true })
vim.keymap.set('i', '<C-b>', '<BS>', { noremap = true })

vim.keymap.set('n', 'y9', 'y$', { noremap = true })
vim.keymap.set('n', 'y0', 'y^', { noremap = true })
