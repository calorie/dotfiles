if vim.fn.has('vim_starting') and vim.fn.has('reltime') then
  vim.g.startuptime = vim.fn.reltime()
  vim.api.nvim_create_augroup('vimrc-startuptime', { clear = true })
  vim.api.nvim_create_autocmd('VimEnter', {
    group = 'vimrc-startuptime',
    callback = function()
      vim.g.startuptime = vim.fn.reltime(vim.g.startuptime)
      vim.cmd('redraw')
      print('startuptime:' .. vim.fn.reltimestr(vim.g.startuptime))
    end,
  })
end

require('basic')
require('plugins')
require('indent')
require('appearance')
require('completion')
require('search')
require('moving')
require('editing')
require('langs')
