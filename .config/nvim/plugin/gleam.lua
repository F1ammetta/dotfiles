local lspconfig = require 'lspconfig'

lspconfig.gleam.setup {
  -- cmd = { 'gleam-lsp' },
  -- filetypes = { 'gleam' },
  -- root_dir = lspconfig.util.root_pattern('rebar.config', 'gleam.toml'),
  -- settings = {
  --   gleam = {
  --     -- Your gleam-lsp settings here
  --   },
  -- },
}
