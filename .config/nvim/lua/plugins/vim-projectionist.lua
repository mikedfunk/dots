return {
  "tpope/vim-projectionist",
  dependencies = {
    {
      "folke/which-key.nvim",
      opts = { defaults = { ["<leader>A"] = { name = "+alternate" } } },
    },
  },
  lazy = false,
  -- event = "BufRead",
  keys = {
    { "<leader>Aa", "<Cmd>A<CR>", noremap = true, desc = "Alternate file" },
    { "<leader>Av", "<Cmd>AV<CR>", noremap = true, desc = "Alternate vsplit" },
    { "<leader>As", "<Cmd>AS<CR>", noremap = true, desc = "Alternate split" },
    { "<leader>At", "<Cmd>AT<CR>", noremap = true, desc = "Alternate tab" },
  },
}
