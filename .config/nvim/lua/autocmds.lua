vim.api.nvim_create_autocmd('FileType', {
  group = 'MyAutoCmd',
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
  group = 'MyAutoCmd',
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

vim.api.nvim_create_autocmd('FileType', {
  group = 'MyAutoCmd',
  pattern = { 'go' },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end,
})
