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
  group = vim.api.nvim_create_augroup("mike_do_not_autoformat_filename", { clear = true }),
  pattern = { "composer.json", "programming_quotes.lua" },
  callback = function()
    vim.b.autoformat = false
  end,
  desc = "don't autoformat by filename",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("mike_do_not_autoformat_filetype", { clear = true }),
  pattern = { "xml" },
  callback = function()
    vim.b.autoformat = false
  end,
  desc = "don't autoformat by filetype",
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

-- auto fold PHP imports only (TODO: not working - overridden by lazyvim autocmd)
-- vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "WinEnter", "CursorMoved", "TextChanged" }, {
--   callback = function(ev)
--     print("DEBUG: Folds recalculated on event:", ev.event)
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   group = vim.api.nvim_create_augroup("mike_auto_fold_php_imports", { clear = true }),
--   pattern = "*.php",
--   callback = function()
--     local start, finish
--
--     -- Find contiguous import block
--     for i = 1, vim.fn.line("$") do
--       local line = vim.fn.getline(i)
--       if line:match("^use ") then
--         start = start or i
--         finish = i
--       elseif start then
--         break
--       end
--     end
--
--     if not start then
--       return
--     end
--
--     -- If already folded, do nothing
--     if vim.fn.foldclosed(start) ~= -1 then
--       return
--     end
--
--     -- Fold it
--     vim.cmd(start .. "," .. finish .. "foldclose")
--   end,
-- })

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
--

-- moved to ~/.support/tmux-dark-mode-watcher.sh invoked by ~/.zshrc
-- When updating dark-notify theme, reload tmux theme
-- vim.api.nvim_create_autocmd("User", {
--   group = vim.api.nvim_create_augroup("mike_tmux_reload_dark_notify", { clear = true }),
--   pattern = "UpdateDarkNotifyTheme",
--   callback = function()
--     -- these tmux plugins must be loaded after theme change or they stop working
--     -- in statusbar because the script just sets tmux variables which are set by their tmux plugins.
--     vim.cmd(
--       "silent! !( defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark "
--         .. "&& tmux source ~/.config/tmux/tmuxline-dark.conf || tmux source ~/.config/tmux/tmuxline-light.conf ) "
--         .. "&& tmux run-shell $TMUX_PLUGIN_MANAGER_PATH/tmux-cpu/cpu.tmux "
--         .. "&& tmux run-shell $TMUX_PLUGIN_MANAGER_PATH/tmux-battery/battery.tmux"
--     )
--   end,
--   desc = "Reload tmux status on dark-notify update",
-- })
