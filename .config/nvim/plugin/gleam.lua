-- local lspconfig = require 'lspconfig'
--
-- lspconfig.nixd.setup {}
--
-- lspconfig.clangd.setup {
--   cmd = { 'clangd' },
-- }

-- lspconfig.gleam.setup {
-- cmd = { 'gleam-lsp' },
-- filetypes = { 'gleam' },
-- root_dir = lspconfig.util.root_pattern('rebar.config', 'gleam.toml'),
-- settings = {
--   gleam = {
--     -- Your gleam-lsp settings here
--   },
-- },
-- }
-- vim.lsp.config('glsl', {
--   cmd = { 'glsl' },
-- })
vim.lsp.config('matlab_ls', {
  cmd = { 'matlab-language-server', '--stdio' },
})
