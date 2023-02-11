vim.opt.imdisable = false
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.imcmdline = false
vim.opt.expandtab = true
vim.opt.foldlevelstart = 99
vim.opt.ffs = 'unix'
vim.opt.encoding = 'utf-8'
vim.opt.suffixes = {
  '.bak', '~', '.swp', '.o', '.info', '.aux', '.log', '.dvi', '.toc',
  '.bbl', '.blg', '.brf', '.cb', '.ind', '.idx', '.ilg', '.inx', '.out',
}

vim.keymap.set('i', ',', ',<Space>', { noremap = true })
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', { noremap = true })
vim.keymap.set('i', '<C-b>', '<BS>', { noremap = true })

vim.keymap.set('n', 'y9', 'y$', { noremap = true })
vim.keymap.set('n', 'y0', 'y^', { noremap = true })

function StripTrailingWhitespace()
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')
  vim.cmd("%s/\\s\\+$//e")
  vim.fn.cursor(l, c)
end
vim.cmd([[command! StripTrailingWhitespace call v:lua.StripTrailingWhitespace()]])
