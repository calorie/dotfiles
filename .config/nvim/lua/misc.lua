vim.api.nvim_set_hl(0, 'EndOfBuffer', { link = 'Ignore' })

vim.cmd([[command! Path echo expand('%:p')]])

vim.api.nvim_set_hl(0, 'ZenkakuSpace', { ctermbg = 'lightblue', bg = 'darkgray', underline = true })
vim.api.nvim_create_autocmd({ 'WinNew', 'BufWinEnter', 'VimEnter' }, {
  group = 'MyAutoCmd',
  callback = function()
    for _, m in ipairs(vim.fn.getmatches()) do
      if m.group == 'ZenkakuSpace' then return end
    end
    vim.fn.matchadd('ZenkakuSpace', '　')
  end,
})

function StripTrailingWhitespace()
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')
  vim.cmd("%s/\\s\\+$//e")
  vim.fn.cursor(l, c)
end
vim.cmd([[command! StripTrailingWhitespace call v:lua.StripTrailingWhitespace()]])
