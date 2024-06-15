vim.opt.scrolloff = 5
vim.opt.textwidth = 0
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.hidden = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.formatoptions = 'lmoq'
vim.opt.belloff = 'all'
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.viminfo = "'50,<1000,s100,\"50"
vim.opt.modelines = 0
vim.opt.clipboard = 'unnamedplus'
vim.opt.shortmess:append { I = true, c = true, W = true }
vim.opt.helpfile = os.getenv('VIMRUNTIME') .. '/doc/help.txt'
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0
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
vim.opt.wildmenu = true
vim.opt.wildchar = ("\t"):byte()
vim.opt.wildmode = 'list:full'
vim.opt.history = 1000
vim.opt.complete:append('k')
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.tagbsearch = false
vim.opt.virtualedit:append('block')
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.expandtab = true
vim.opt.foldlevelstart = 99
vim.opt.ffs = 'unix'
vim.opt.encoding = 'utf-8'
vim.opt.suffixes = {
  '.bak', '~', '.swp', '.o', '.info', '.aux', '.log', '.dvi', '.toc',
  '.bbl', '.blg', '.brf', '.cb', '.ind', '.idx', '.ilg', '.inx', '.out',
}
vim.opt.mouse = nil

vim.lsp.set_log_level('off')

vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
-- vim.g.loaded_man = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
-- vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.skip_loading_mswin = 1

vim.g.mapleader = ','
vim.g.is_mac = (vim.fn.has('mac') or vim.fn.has('macunix') or vim.fn.has('gui_macvim'))

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
if vim.g.is_mac then
  vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
  if vim.fn.filereadable(vim.g.python3_host_prog) == 0 then
    vim.g.python3_host_prog = '/usr/local/bin/python3'
  end
  vim.g.ruby_host_prog = '~/.rbenv/shims/neovim-ruby-host'
end
vim.g.omni_sql_default_compl_type = 'syntax'
vim.g.omni_sql_no_default_maps = 1
