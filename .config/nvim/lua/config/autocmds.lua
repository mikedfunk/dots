-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  group = vim.api.nvim_create_augroup("grep_open_quickfix", { clear = true }),
  pattern = { "[^l]*", "l*" },
  command = "cwindow",
  desc = "Grep open quickfix",
})
