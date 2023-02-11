vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0

vim.api.nvim_create_augroup('Indent', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'Indent',
  pattern = {
    'ruby', 'eruby', 'yaml', 'json', 'lua', 'go',
    'html', 'javascript', 'sh', 'zsh', 'vim', 'scala',
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'Indent',
  pattern = {
    'c', 'cpp', 'java', 'perl', 'php', 'python', 'sql',
    'xml', 'css', 'diff', 'swift',
  },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end,
})
