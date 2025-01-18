return {
  -- this is installed via LazyExtras and customized here
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = { command = false }, -- do not auto-pair in command or search mode
    },
  },
  { "tpope/vim-apathy", event = "VeryLazy" },
  -- { "sickill/vim-pasta", event = "BufRead" },
  { "echasnovski/mini.splitjoin", event = "VeryLazy", opts = {} },
  {
    "tpope/vim-projectionist",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            {
              "<leader>A",
              group = "+alternate",
              icon = "󱂬",
            },
          },
        },
      },
    },
    lazy = false,
    -- event = "BufRead",
    commands = {
      "A",
      "AV",
      "AS",
      "AT",
    },
    keys = {
      { "<leader>Aa", "<Cmd>A<CR>", noremap = true, desc = "Alternate file" },
      { "<leader>Av", "<Cmd>AV<CR>", noremap = true, desc = "Alternate vsplit" },
      { "<leader>As", "<Cmd>AS<CR>", noremap = true, desc = "Alternate split" },
      { "<leader>At", "<Cmd>AT<CR>", noremap = true, desc = "Alternate tab" },
    },
  },
  {
    "ChrisLetter/cspell-ignore",
    opts = { cspell_path = "./cspell.json" },
    commands = { "CspellIgnore" },
    keys = {
      { "<Leader>ci", "<Cmd>CspellIgnore<CR>", noremap = true, desc = "Cspell Ignore" },
    },
  },
}
