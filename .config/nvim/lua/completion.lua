vim.opt.wildmenu = true
vim.opt.wildchar = ("\t"):byte()
vim.opt.wildmode = 'list:full'
vim.opt.history = 1000
vim.opt.complete:append('k')
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.keymap.set('c', '<C-p>', '<Up>', { noremap = true })
vim.keymap.set('c', '<Up>', '<C-p>', { noremap = true })
vim.keymap.set('c', '<C-n>', '<Down>', { noremap = true })
vim.keymap.set('c', '<Down>', '<C-n>', { noremap = true })
