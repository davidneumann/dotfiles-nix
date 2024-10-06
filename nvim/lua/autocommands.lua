vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'Red' })
    vim.cmd 'match ExtraWhitespace /\\s\\+$/'
  end,
})
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'Red' })
    vim.cmd 'match ExtraWhitespace /\\s\\+\\%#\\@<!$/'
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'Red' })
    vim.cmd 'match ExtraWhitespace /\\s\\+$/'
  end,
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'Red' })
    vim.cmd 'call clearmatches()'
  end,
})
