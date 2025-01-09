-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "+", "<C-a>", { noremap = true, desc = "Increment" })
vim.keymap.set("n", "-", "<C-x>", { noremap = true, desc = "Decrement" })

vim.keymap.set("n", "y<c-g>", function()
  local path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard')
end, { noremap = true, desc = "Copy path" })

vim.keymap.set("n", "zl", "20l", { noremap = true, desc = "Move right 20" })
vim.keymap.set("n", "zh", "20h", { noremap = true, desc = "Move left 20" })

-- vim.keymap.set("n", "go", "<Cmd>Telescope lsp_incoming_calls<CR>", { noremap = true, desc = "Incoming Calls" })
-- vim.keymap.set("n", "gO", "<Cmd>Telescope lsp_outgoing_calls<CR>", { noremap = true, desc = "Outgoing Calls" })

vim.keymap.set("n", "<leader>w", "<Cmd>w<CR><Esc>", { noremap = true, desc = "Save File" })

vim.keymap.set("n", "<c-q>", function()
  if package.loaded["trouble"] and require("trouble").is_open() then
    require("trouble").close()
    vim.cmd("cclose")

    return
  end

  if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end, { noremap = true, desc = "Toggle Quickfix" })

vim.keymap.set("n", "[B", "<Cmd>BufferLineMovePrev<CR>", { noremap = true, desc = "Move Buffer Left" })
vim.keymap.set("n", "]B", "<Cmd>BufferLineMoveNext<CR>", { noremap = true, desc = "Move Buffer Right" })

vim.keymap.del("n", "H")
vim.keymap.del("n", "L")

vim.keymap.set("i", "<c-space", function()
  return require("cmp.config.mapping").complete()
end, { noremap = true, desc = "Complete" })

-- vim.keymap.set("n", "<leader>fe", function()
--   if vim.bo.filetype == "neo-tree" then
--     vim.cmd("norm q")
--   else
--     vim.cmd("Neotree reveal_file=%")
--   end
-- end, { remap = true, desc = "Explorer NeoTree (Root dir)" })
