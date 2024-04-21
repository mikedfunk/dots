-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  group = vim.api.nvim_create_augroup("grep_open_quickfix", { clear = true }),
  pattern = { "[^l]*", "l*" },
  command = "cwindow",
  desc = "Grep open quickfix",
})

-- enable lsp inlay hints if available
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = true }),
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.supports_method("textDocument/inlayHint") then
      local bufnr = args.buf
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end,
})
