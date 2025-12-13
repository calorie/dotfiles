vim.loader.enable()
vim.opt.scrolloff = 5
vim.opt.textwidth = 0
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.formatoptions = 'lmoq'
vim.opt.belloff = 'all'
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.modelines = 0
vim.opt.clipboard = 'unnamedplus'
vim.opt.shortmess:append { I = true, c = true, W = true }
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.number = true
vim.opt.display = 'uhex'
vim.opt.previewheight = 15
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.listchars = { tab = '>.', trail = '_', extends = '>', precedes = '<' }
vim.opt.wildchar = ("\t"):byte()
vim.opt.wildmode = 'list:full'
vim.opt.history = 1000
vim.opt.complete:append('k')
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tagbsearch = false
vim.opt.virtualedit:append('block')
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.expandtab = true
vim.opt.foldlevelstart = 99
vim.opt.ffs = 'unix'
vim.opt.suffixes = {
  '.bak', '~', '.swp', '.o', '.info', '.aux', '.log', '.dvi', '.toc',
  '.bbl', '.blg', '.brf', '.cb', '.ind', '.idx', '.ilg', '.inx', '.out',
}
vim.opt.mouse = nil
vim.opt.guicursor = "n-v-c-sm-ci:block,i-ve:ver25-Cursor,r-cr-o:hor20"
vim.opt.termguicolors = true
vim.opt.secure = true
vim.opt.updatetime = 250

vim.g.disabled_built_ins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'matchit',
  'matchparen',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'tar',
  'tarPlugin',
  'rrhelper',
  'spellfile_plugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
  'tutor',
  'rplugin',
  'syntax',
  'synmenu',
  'optwin',
  'compiler',
  'bugreport',
}
for _, plugin in pairs(vim.g.disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end
vim.g.editorconfig = false
vim.g.termfeatures = { osc52 = false }
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.did_indent_on = 1
vim.g.skip_loading_mswin = 1

vim.g.mapleader = ','

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
if vim.fn.executable('python3') == 1 then
  vim.g.python3_host_prog = vim.fn.exepath('python3')
end
vim.g.ruby_host_prog = '~/.rbenv/shims/neovim-ruby-host'

vim.g.omni_sql_default_compl_type = 'syntax'
vim.g.omni_sql_no_default_maps = 1

vim.filetype.add({
  extension = {
    tf = 'terraform',
  },
})
