if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

vim.keymap.set("i", "<C-s>", vim.cmd.w)
vim.keymap.set("n", "<C-s>", vim.cmd.w)
vim.keymap.set("i", "<C-z>", vim.cmd.u)
vim.keymap.set("n", "<C-z>", vim.cmd.u)
vim.keymap.set("i", "<A-z>", vim.cmd.redo)
vim.keymap.set("n", "<A-j>", ":m+<CR>")
vim.keymap.set("i", "<A-j>", "<C-[>:m+<CR>")
vim.keymap.set("n", "<A-z>", vim.cmd.redo)
vim.keymap.set("n", "<C-a>", "ggVG")
vim.keymap.set("n", "<A-k>", ":m-2<CR>")
vim.keymap.set("i", "<A-k>", "<C-[>:m-2<CR>")
vim.keymap.set("i", "<C-a>", "<C-[>ggVG")
vim.keymap.set("i", "<A-Up>", "<Esc>:m-2<CR>==gi")
vim.keymap.set("n", "<A-k>", ":m-2<CR>==gi")
vim.keymap.set("n", "<A-j>", ":m+<CR>==gi")
vim.keymap.set("i", "<A-Down>", "<Esc>:m+<CR>==gi")

-- set shell to zsh
vim.o.shell = "zsh"


vim.api.nvim_exec([[
    let g:copilot_filetypes = {'': v:true}
]], false)

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
      vim.log.levels.ERROR
    )
  end
end

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)
