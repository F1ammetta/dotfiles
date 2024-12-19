vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('TermOpen', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local termbuf = nil

vim.keymap.set('n', '<leader>st', function()
  vim.cmd.vnew()
  if termbuf == nil then
    vim.cmd 'term'
    termbuf = vim.api.nvim_get_current_buf()
  else
    vim.api.nvim_set_current_buf(termbuf)
  end
  vim.cmd.wincmd 'L'
  -- start in terminal mode
  vim.cmd [[startinsert]]
  -- set width
  vim.cmd [[vertical resize 90]]
end, { noremap = true, desc = 'Open terminal in split' })
