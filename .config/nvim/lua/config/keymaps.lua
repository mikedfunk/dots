-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "y<c-g>", function()
  local path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard')
end, { noremap = true, desc = "Copy path" })

vim.keymap.set("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { noremap = true, desc = "Code Action" })

vim.keymap.set("i", "<c-v>", function()
  vim.lsp.buf.signature_help()
end, { noremap = true, desc = "Signature help" })

vim.keymap.set("n", "go", "<Cmd>Telescope lsp_incoming_calls<CR>", { noremap = true, desc = "Incoming Calls" })
vim.keymap.set("n", "gO", "<Cmd>Telescope lsp_outgoing_calls<CR>", { noremap = true, desc = "Outgoing Calls" })