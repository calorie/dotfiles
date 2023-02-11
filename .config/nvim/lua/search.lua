vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.keymap.set('n', '<ESC><ESC>', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-c><C-c>', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>sb', ':%s/<C-r><C-w>//g<Left><Left>', { noremap = true })
vim.keymap.set('v', '<Leader>sb', [["xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//g<Left><Left>]], { noremap = true })
