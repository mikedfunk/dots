-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("mike_grep_open_quickfix", { clear = true }),
  pattern = { "[^l]*", "l*" },
  command = "cwindow",
  desc = "Grep open quickfix",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd("WinEnter", {
  group = vim.api.nvim_create_augroup("mike_hide_cursorline", { clear = true }),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
  desc = "Hide cursor line",
})
vim.api.nvim_create_autocmd("WinLeave", {
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

vim.api.nvim_create_autocmd("Filetype", {
  group = vim.api.nvim_create_augroup("mike_plantuml_commentstring", { clear = true }),
  pattern = { "plantuml" },
  callback = function()
    vim.bo.commentstring = "' %s"
  end,
  desc = "plantuml commentstring",
})

vim.api.nvim_create_autocmd("Filetype", {
  group = vim.api.nvim_create_augroup("mike_neon_commentstring", { clear = true }),
  pattern = { "neon" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
  desc = "neon commentstring",
})

-- BUG: this still focuses sometimes
-- vim.api.nvim_create_autocmd("CursorHold", {
--   group = vim.api.nvim_create_augroup("lsp_def_cursorhold", { clear = true }),
--   pattern = "*",
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local clients = vim.lsp.get_clients({ bufnr = bufnr })
--     if #clients > 0 then
--       vim.lsp.buf.hover({ focusable = false, focus = false })
--     end
--   end,
--   desc = "lsp def cursorhold",
-- })

-- moved to ftplugin/php.lua
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   group = vim.api.nvim_create_augroup("mike_php_auto_fold_use_statements", { clear = true }),
--   pattern = "*.php",
--   callback = function()
--     vim.cmd([[silent! g/^use /normal! zc]]) -- Collapse only `use` statements
--   end,
-- })

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#copilot
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local bufnr = args.buf
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--
--     if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
--       vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
--
--       vim.keymap.set(
--         "i",
--         "<a-y>",
--         vim.lsp.inline_completion.get,
--         { desc = "LSP: accept inline completion", buffer = bufnr }
--       )
--       vim.keymap.set(
--         "i",
--         "<a-n>",
--         vim.lsp.inline_completion.select,
--         { desc = "LSP: switch inline completion", buffer = bufnr }
--       )
--     end
--   end,
-- })
