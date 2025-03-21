return {
  -- this is installed via LazyExtras and customized here
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = { command = false }, -- do not auto-pair in command or search mode
    },
  },
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
  -- {
  --   -- TODO: this fails to install https://github.com/andythigpen/nvim-coverage/issues/60
  --   -- needed for nvim-coverage PHP cobertura parser. Requires `brew install luajit`
  --   "vhyrro/luarocks.nvim",
  --   priority = 1000,
  --   opts = {
  --     rocks = { "lua-xmlreader" },
  --   },
  -- },
  -- {
  --   -- "andythigpen/nvim-coverage",
  --   "strottie/nvim-coverage",
  --   branch = "strottie-cpp-cobertura",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "folke/tokyonight.nvim",
  --     "folke/snacks.nvim",
  --   },
  --   opts = function()
  --     return {
  --       highlights = {
  --         covered = { fg = Snacks.util.color("DiagnosticOk") },
  --         uncovered = { fg = Snacks.util.color("DiagnosticError") },
  --       },
  --       auto_reload = true,
  --       lcov_file = "./coverage/lcov.info",
  --     }
  --   end,
  --   keys = {
  --     {
  --       "<leader>tc",
  --       function()
  --         if require("coverage.signs").is_enabled() then
  --           require("coverage").clear()
  --         else
  --           require("coverage").load(true)
  --         end
  --       end,
  --       noremap = true,
  --       desc = "Toggle Coverage",
  --     },
  --   },
  -- },
}
