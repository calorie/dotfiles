vim.api.nvim_set_hl(0, 'EndOfBuffer', { link = 'Ignore' })

vim.cmd([[command! Path echo expand('%:p')]])

vim.api.nvim_set_hl(0, 'ZenkakuSpace', { ctermbg = lightblue, guibg = darkgray, underline = true })
vim.cmd[[match ZenkakuSpace /　/]]

function StripTrailingWhitespace()
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')
  vim.cmd("%s/\\s\\+$//e")
  vim.fn.cursor(l, c)
end
vim.cmd([[command! StripTrailingWhitespace call v:lua.StripTrailingWhitespace()]])
