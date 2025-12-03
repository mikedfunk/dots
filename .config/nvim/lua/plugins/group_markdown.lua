return {
  -- {
  --   "bullets-vim/bullets.vim",
  --   ft = "markdown",
  --   init = function()
  --     vim.g.bullets_checkbox_markers = "    x" -- default: ' .oOX'
  --   end,
  -- },
  -- use utf-8 symbols directly
  -- {
  --   "bngarren/checkmate.nvim",
  --   ft = "markdown",
  --   opts = {},
  -- },
  -- NOTE: This is a LazyVim extra, just adding another Augur here
  -- {
  --   "monaqa/dial.nvim",
  --   lazy = false,
  --   opts = function()
  --     local opts = require("lazyvim.plugins.extras.editor.dial").opts()
  --     local augend = require("dial.augend")
  --
  --     local checkboxes = augend.constant.new({
  --       -- pattern_regexp = "\\[.]\\s", -- TODO: doesn't work
  --       elements = { "[ ]", "[x]", "[-]" },
  --       word = false,
  --       cyclic = true,
  --     })
  --
  --     opts.groups.markdown = opts.groups.markdown or {}
  --     table.insert(opts.groups.markdown, checkboxes)
  --     return opts
  --   end,
  --   -- keys = {
  --   --   { "<CR>", "<Cmd>norm <C-a><CR>", mode = "n", noremap = true, desc = "Dial" },
  --   -- },
  -- },
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {},
  },
  -- {
  --   "wurli/contextindent.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = { pattern = "*" },
  -- },
  -- { "dhruvasagar/vim-table-mode", ft = "markdown" },
  {
    -- lsp stuff for code embedded in markdown
    "jmbuhr/otter.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("otter").activate()
    end,
  },
}
