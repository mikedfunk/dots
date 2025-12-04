return {
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "gitcommit" },
    keys = {
      -- Insert mode mappings
      { "<cr>", "<Plug>(bullets-newline)", mode = "i", buffer = 0, desc = "New bullet line" },
      -- This isn't triggering for some reason:
      -- { "<C-cr>", "<cr>", mode = "i", buffer = 0, desc = "Normal carriage return" },

      -- Normal mode mappings
      { "o", "<Plug>(bullets-newline)", mode = "n", buffer = 0, desc = "New bullet line" },
      -- { "gN", "<Plug>(bullets-renumber)", mode = "n", buffer = 0, desc = "Renumber bullets" },
      -- { "<leader>x", "<Plug>(bullets-toggle-checkbox)", mode = "n", buffer = 0, desc = "Toggle checkbox" },
      { ">>", "<Plug>(bullets-demote)", mode = "n", buffer = 0, desc = "Demote bullet" },
      { "<<", "<Plug>(bullets-promote)", mode = "n", buffer = 0, desc = "Promote bullet" },

      -- Visual mode mappings
      -- { "gN", "<Plug>(bullets-renumber)", mode = "v", buffer = 0, desc = "Renumber bullets" },
      { ">", "<Plug>(bullets-demote)", mode = "v", buffer = 0, desc = "Demote bullet" },
      { "<", "<Plug>(bullets-promote)", mode = "v", buffer = 0, desc = "Promote bullet" },

      -- Insert mode mappings for indentation
      -- { "<C-t>", "<Plug>(bullets-demote)", mode = "i", buffer = 0, desc = "Demote bullet" },
      -- { "<C-d>", "<Plug>(bullets-promote)", mode = "i", buffer = 0, desc = "Promote bullet" },
    },
    init = function()
      vim.g.bullets_set_mappings = 0 -- remove some features/mappings above
      vim.g.bullets_checkbox_markers = table.concat({
        " ", -- unchecked
        " ", -- partial: < 33%
        " ", -- partial: > 33%, < 66%
        " ", -- partial: > 66%, < 100%
        "x", -- checked
      }, "")
    end,
  },
  -- NOTE: This is installed via a lazyvim extra, just configuring it here
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      bullet = {
        icons = {
          "", -- level 1 (top)
          "", -- level 2
          "󰣏", -- level 3
          "󱀝", -- level 4
        },
      },
    },
  },
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
  -- {
  --   "yousefhadder/markdown-plus.nvim",
  --   ft = "markdown",
  --   opts = {
  --     features = {
  --       list_management = true, -- default: true (list auto-continue / indent / renumber / checkboxes)
  --       text_formatting = false, -- default: true (bold/italic/strike/code + clear)
  --       headers_toc = false, -- default: true (headers nav + TOC generation & window)
  --       links = false, -- default: true (insert/edit/convert/reference links)
  --       images = false, -- default: true (insert/edit image links + toggle link/image)
  --       quotes = false, -- default: true (blockquote toggle)
  --       callouts = false, -- default: true (GFM callouts/admonitions)
  --       code_block = false, -- default: true (visual selection -> fenced block)
  --       table = false, -- default: true (table creation & editing)
  --       footnotes = false, -- default: true (footnote insertion/navigation/listing)
  --     },
  --   },
  -- },
  -- {
  --   "gaoDean/autolist.nvim",
  --   ft = { "markdown" },
  --   keys = {
  --     {
  --       "<CR>",
  --       "<CR><Cmd>AutolistNewBullet<CR>",
  --       mode = "i",
  --       buffer = 0,
  --       desc = "New list bullet",
  --     },
  --   },
  --   opts = {},
  -- },
  -- {
  --   "wurli/contextindent.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = { pattern = "*" },
  -- },
  -- { "dhruvasagar/vim-table-mode", ft = "markdown" },
  -- lsp stuff for code embedded in markdown
  {
    "jmbuhr/otter.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("otter").activate()
    end,
  },
}
