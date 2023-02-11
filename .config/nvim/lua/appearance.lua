vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.number = true
vim.opt.display = 'uhex'
vim.opt.previewheight = 15
vim.opt.cmdheight = 1
vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.redrawtime = 10000
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.listchars = { tab = '>.', trail = '_', extends = '>', precedes = '<' }

vim.api.nvim_set_hl(0, 'ZenkakuSpace', { ctermbg = lightblue, guibg = darkgray, underline = true })
vim.cmd[[match ZenkakuSpace /　/]]

vim.api.nvim_set_hl(0, 'EndOfBuffer', { link = 'Ignore' })
