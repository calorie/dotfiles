vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
if vim.g.is_mac then
  vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
  vim.g.ruby_host_prog = '~/.rbenv/shims/neovim-ruby-host'
end
vim.g.omni_sql_default_compl_type = 'syntax'

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = 'MyAutoCmd',
  pattern = '*.slim',
  command = 'setfiletype slim',
})
