return {
  -- this is installed via LazyExtras and customized here
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = { command = false }, -- do not auto-pair in command or search mode
    },
  },
  -- { "sickill/vim-pasta", event = "BufRead" },
  { "nvim-mini/mini.splitjoin", event = "VeryLazy", opts = {} },
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
    -- needed for nvim-coverage PHP cobertura parser. Requires `brew install luajit`
    "vhyrro/luarocks.nvim",
    priority = 1000,
    opts = {
      rocks = { "lua-xmlreader" },
    },
  },
  {
    "andythigpen/nvim-coverage",
    -- "strottie/nvim-coverage", branch = "strottie-cpp-cobertura",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = function()
      require("snacks")
        .toggle({
          name = "Coverage Markers",
          get = require("coverage.signs").is_enabled,
          set = function(state)
            if state then
              require("coverage").load(true)
            else
              require("coverage").clear()
            end
          end,
        })
        :map("<leader>uv")

      return {
        highlights = {
          covered = { fg = require("snacks").util.color("DiagnosticOk") },
          uncovered = { fg = require("snacks").util.color("DiagnosticError") },
        },
        auto_reload = true,
        lcov_file = "./coverage/lcov.info",
      }
    end,
    -- keys = {
    --   {
    --     "<leader>uv",
    --     function()
    --       if require("coverage.signs").is_enabled() then
    --         require("coverage").clear()
    --       else
    --         require("coverage").load(true)
    --       end
    --     end,
    --     noremap = true,
    --     desc = "Toggle Test Coverage Markers",
    --   },
    -- },
  },
  -- TODO: doesn't work with treesitter main branch :/
  -- {
  --   "jdrupal-dev/code-refactor.nvim",
  --   filetypes = {
  --     "javascript",
  --     "javascriptreact",
  --     "typescript",
  --     "typescriptreact",
  --     "php",
  --   },
  --   opts = {},
  --   keys = {
  --     { "<Leader>rt", "<Cmd>CodeActions all<CR>", buffer = true, noremap = true, desc = "Treesitter Refactor Menu" },
  --   },
  -- },
}
