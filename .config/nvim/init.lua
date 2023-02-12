vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

if vim.fn.has('vim_starting') and vim.fn.has('reltime') then
  vim.g.startuptime = vim.fn.reltime()
  vim.api.nvim_create_autocmd('VimEnter', {
    group = 'MyAutoCmd',
    callback = function()
      vim.g.startuptime = vim.fn.reltime(vim.g.startuptime)
      vim.cmd('redraw')
      print('startuptime:' .. vim.fn.reltimestr(vim.g.startuptime))
    end,
  })
end

require('options')
require('plugins')
require('autocmds')
require('keymaps')
require('misc')
