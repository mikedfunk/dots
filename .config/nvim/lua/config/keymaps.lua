-- # vim: set fdm=marker:
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

vim.keymap.set("n", "<c-q>", "<Leader>xq", { remap = true, desc = "Toggle Quickfix" })
-- vim.keymap.set("n", "<c-q>", function()
--   if package.loaded["trouble"] and require("trouble").is_open() then
--     require("trouble").close()
--     vim.cmd("cclose")
--
--     return
--   end
--
--   if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
--     vim.cmd("copen")
--   else
--     vim.cmd("cclose")
--   end
-- end, { noremap = true, desc = "Toggle Quickfix" })

vim.keymap.set("n", "[B", "<Cmd>BufferLineMovePrev<CR>", { noremap = true, desc = "Move Buffer Left" })
vim.keymap.set("n", "]B", "<Cmd>BufferLineMoveNext<CR>", { noremap = true, desc = "Move Buffer Right" })

vim.keymap.del("n", "H")
vim.keymap.del("n", "L")

vim.keymap.set("i", "<c-space>", function()
  require("blink.cmp").show()
end, { noremap = true, desc = "Complete" })

-- vim.keymap.set("n", "<leader>fe", function()
--   if vim.bo.filetype == "neo-tree" then
--     vim.cmd("norm q")
--   else
--     vim.cmd("Neotree reveal_file=%")
--   end
-- end, { remap = true, desc = "Explorer NeoTree (Root dir)" })
--
--
-- Go to next/previous reference {{{
local refs = {}
local idx = 0
local last_symbol = nil

local function normalize_location(item)
  if item.targetUri and item.targetRange then
    return { uri = item.targetUri, range = item.targetRange }
  elseif item.uri and item.range then
    return item
  elseif item.user_data and item.user_data.uri and item.user_data.range then
    return { uri = item.user_data.uri, range = item.user_data.range }
  end
  return nil
end

local function jump_to_ref(item)
  local loc = normalize_location(item)
  if not loc then
    return
  end

  local fname = vim.uri_to_fname(loc.uri)
  vim.cmd("edit " .. fname)

  local line = (loc.range.start.line or 0) + 1
  local col = (loc.range.start.character or 0) + 1
  vim.fn.cursor(line, col)
  vim.cmd("normal! zz")
end

local function get_current_symbol()
  return vim.fn.expand("<cword>")
end

local function fetch_references_and_jump(forward)
  local symbol = get_current_symbol()
  if symbol ~= last_symbol then
    -- new symbol, fetch references
    vim.lsp.buf.references(nil, {
      on_list = function(res)
        refs = res.items or {}
        last_symbol = symbol
        idx = forward and 1 or #refs
        if refs[idx] then
          jump_to_ref(refs[idx])
        else
          vim.notify("No references found", vim.log.levels.INFO)
        end
      end,
    })
  else
    -- same symbol, just cycle
    if #refs == 0 then
      vim.notify("No references cached", vim.log.levels.INFO)
      return
    end
    idx = forward and (idx % #refs + 1) or (idx - 2 + #refs) % #refs + 1
    jump_to_ref(refs[idx])
  end
end

-- Keymaps
vim.keymap.set("n", "]r", function()
  fetch_references_and_jump(true)
end, { desc = "Next LSP reference" })
vim.keymap.set("n", "[r", function()
  fetch_references_and_jump(false)
end, { desc = "Previous LSP reference" })
-- }}}
