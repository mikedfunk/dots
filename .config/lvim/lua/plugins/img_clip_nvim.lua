return {
  "HakonHarnes/img-clip.nvim",
  event = "BufEnter",
  ft = 'markdown',
  opts = {
    relative_to_current_file = true,
  },
  keys = {
    { "<Leader>mv", "<Cmd>PasteImage<CR>", desc = "Paste clipboard image" },
  },
}
