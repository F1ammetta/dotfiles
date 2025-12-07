-- local lspconfig = require 'lspconfig'

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
})

vim.lsp.config('pyrefly', {
  cmd = { 'pyrefly', 'lsp' },
  settings = {
    matlab = {
      -- This is the crucial part.
      -- Point it to the ROOT of your shim directory (NOT the bin dir)
      installPath = '/home/fiammetta/.local/',

      -- You may also want to add this, which you remembered from before
      -- (This is unrelated to the crash, but good to keep)
      -- installpath = "/usr/local/MATLAB/R2024a/bin/matlab"
    },
  },
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
})

vim.lsp.config('matlab-ls', {
  cmd = { 'matlab-language-server', 'stdio' },
})

vim.lsp.config('glslls', {
  cmd = { 'glslls' },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  -- settings = {
  --   nixd = {
  --     nixpkgs = {
  --       expr = "import <nixpkgs> { }",
  --     },
  --     formatting = {
  --       command = { "nixfmt" }, -- or nixfmt or nixpkgs-fmt
  --     },
  --     -- options = {
  --     --   nixos = {
  --     --       expr = '(builtins.getflake "/path/to/flake").nixosconfigurations.configname.options',
  --     --   },
  --     --   home_manager = {
  --     --       expr = '(builtins.getflake "/path/to/flake").homeconfigurations.configname.options',
  --     --   },
  --     -- },
  --   },
  -- },
})

vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import <nixpkgs> { }',
      },
      formatting = {
        command = { 'nixfmt' }, -- or nixfmt or nixpkgs-fmt
      },
      -- options = {
      --   nixos = {
      --       expr = '(builtins.getflake "/path/to/flake").nixosconfigurations.configname.options',
      --   },
      --   home_manager = {
      --       expr = '(builtins.getflake "/path/to/flake").homeconfigurations.configname.options',
      --   },
      -- },
    },
  },
})
