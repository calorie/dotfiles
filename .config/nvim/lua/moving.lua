vim.opt.tagbsearch = false
vim.opt.virtualedit:append('block')

vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

vim.keymap.set('n', '0', '^', { noremap = true })
-- vim.keymap.set('n', '9', '$', { noremap = true })

vim.keymap.set('n', '<Space>j', '<C-f>', { noremap = true })
vim.keymap.set('n', '<Space>k', '<C-b>', { noremap = true })

vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })

vim.keymap.set('n', 'tc', ':<C-u>tabnew<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'tx', ':<C-u>tabclose<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'to', ':<C-u>tabonly<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space><Space>', ':<C-u>tabnext<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<BS><BS>', ':<C-u>tabprevious<cr>', { noremap = true, silent = true })

vim.keymap.set('i', '<C-e>', '<END>', { noremap = true })
vim.keymap.set('i', '<C-a>', '<HOME>', { noremap = true })
vim.keymap.set('i', '<C-j>', '<Down>', { noremap = true })
vim.keymap.set('i', '<C-k>', '<Up>', { noremap = true })
vim.keymap.set('i', '<C-h>', '<Left>', { noremap = true })
vim.keymap.set('i', '<C-l>', '<Right>', { noremap = true })

vim.keymap.set('v', 'v', '$h', { noremap = true })
vim.keymap.set('v', '1', '^', { noremap = true })

vim.api.nvim_create_augroup('CursorLine', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'CursorLine',
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
})
