vim.g.mapleader = ','
vim.opt.scrolloff = 5
vim.opt.textwidth = 0
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.hidden = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.formatoptions = 'lmoq'
vim.opt.belloff = 'all'
vim.opt.browsedir = 'buffer'
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.viminfo = "'50,<1000,s100,\"50"
vim.opt.modelines = 0
vim.opt.clipboard = 'unnamedplus'
vim.opt.shortmess:append { I = true, c = true, W = true }
vim.opt.helpfile = os.getenv('VIMRUNTIME') .. '/doc/help.txt'

vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.skip_loading_mswin = 1

vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('i', '<C-c>', '<ESC>', { noremap = true })

vim.cmd([[command! Path echo expand('%:p')]])

vim.g.is_mac = (vim.fn.has('mac') or vim.fn.has('macunix') or vim.fn.has('gui_macvim'))
