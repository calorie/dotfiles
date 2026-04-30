vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

if vim.fn.has('vim_starting') == 1 and vim.fn.has('reltime') == 1 then
  vim.g.startuptime = vim.fn.reltime()
  vim.api.nvim_create_autocmd('VimEnter', {
    group = 'MyAutoCmd',
    once = true,
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
