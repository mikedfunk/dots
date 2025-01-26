-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  group = vim.api.nvim_create_augroup("mike_grep_open_quickfix", { clear = true }),
  pattern = { "[^l]*", "l*" },
  command = "cwindow",
  desc = "Grep open quickfix",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = vim.api.nvim_create_augroup("mike_hide_cursorline", { clear = true }),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
  desc = "Hide cursor line",
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = vim.api.nvim_create_augroup("mike_auto_cursorline", { clear = true }),
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
  desc = "Hide cursor line",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("mike_dont_autoformat", { clear = true }),
  pattern = { "composer.json", "programming_quotes.lua" },
  callback = function()
    vim.b.autoformat = false
  end,
  desc = "dont autoformat these",
})

vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = vim.api.nvim_create_augroup("mike_plantuml_commentstring", { clear = true }),
  pattern = { "plantuml" },
  callback = function()
    vim.bo.commentstring = "' %s"
  end,
  desc = "plantuml commentstring",
})

vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = vim.api.nvim_create_augroup("mike_neon_commentstring", { clear = true }),
  pattern = { "neon" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
  desc = "neon commentstring",
})
