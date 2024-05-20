return {
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      bullets = { "•", "", "♦", "⋄" },
      checkbox = { unchecked = "󰄱 ", checked = " " },
      -- checkbox = { unchecked = "□ ", checked = "▣ " },
      -- checkbox = { unchecked = "󰄱 ", checked = " " },
    },
  },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   ft = { "markdown", "norg", "rmd", "org" },
  --   -- opts = {
  --   --   markdown = { fat_headlines = false },
  --   --   norg = { fat_headlines = false },
  --   --   rmd = { fat_headlines = false },
  --   --   org = { fat_headlines = false },
  --   -- },
  --   opts = function(_, opts)
  --     for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
  --       opts[ft] = {
  --         fat_headlines = false,
  --         headline_highlights = {},
  --         -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
  --         bullets = {},
  --       }
  --       for i = 1, 6 do
  --         local hl = "Headline" .. i
  --         vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
  --         table.insert(opts[ft].headline_highlights, hl)
  --       end
  --     end
  --     return opts
  --   end,
  --   config = function(_, opts)
  --     -- PERF: schedule to prevent headlines slowing down opening a file
  --     vim.schedule(function()
  --       require("headlines").setup(opts)
  --       require("headlines").refresh()
  --     end)
  --   end,
  -- },
  {
    "SidOfc/mkdx",
    ft = "markdown",
    init = function()
      vim.g["mkdx#settings"] = {
        checkbox = { toggles = { " ", "-", "X" } },
        insert_indent_mappings = 1, -- <c-t> to indent, <c-d> to unindent
        -- highlight = { enable = true },
        links = { conceal = 1 },
        map = { prefix = "<leader>m" },
        -- tab = { enable = 0 },
      }
    end,
    config = function()
      vim.keymap.set(
        "n",
        "<cr>",
        "<Plug>(mkdx-checkbox-prev-n)",
        { buffer = true, noremap = true, desc = "Toggle Checkbox" }
      )
    end,
  },
  {
    "mickael-menu/zk-nvim",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = { defaults = { ["<leader>z"] = { name = "+zettelkasten" } } },
      },
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "markdown",
    branch = "main",
    keys = {
      { "<leader>zn", '<Cmd>ZkNew { title = vim.fn.input("Title: ") }<CR>', noremap = true, desc = "New" },
      { "<leader>zo", '<Cmd>ZkNotes { sort = { "modified" } }<CR>', noremap = true, desc = "Open" },
      { "<leader>zt", "<Cmd>ZkTags<CR>", noremap = true, desc = "Tags" },
      {
        "<leader>zs",
        '<Cmd>ZkNotes { sort = { "modified" }, match = vim.fn.input("Search: ") }<CR>',
        noremap = true,
        desc = "Search",
      },

      { "<leader>zs", "<cmd>'<,'>ZkMatch<CR>", noremap = true, desc = "Search", mode = "v" },
      { "<leader>zt", "<cmd>'<,'>ZkNewFromTitleSelection<CR>", noremap = true, desc = "New from Title", mode = "v" },
      {
        "<leader>zc",
        "<cmd>'<,'>ZkNewFromContentSelection<CR>",
        noremap = true,
        desc = "New from Content",
        mode = "v",
      },
    },
    -- opts or config = true will not work, it can't find the module
    config = function()
      -- starts language server
      require("zk").setup({
        picker = "telescope",
      })
    end,
    -- TODO:
    -- require("nvim-treesitter.configs").setup({
    --   -- ...
    --   highlight = {
    --     -- ...
    --     additional_vim_regex_highlighting = { "markdown" }
    --   },
    -- })
  },
  {
    "wallpants/github-preview.nvim",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = { defaults = { ["<leader>m"] = { name = "+markdown" } } },
      },
    },
    ft = "markdown",
    cmd = { "GithubPreviewStart", "GithubPreviewToggle", "GithubPreviewStop" },
    keys = {
      { "<Leader>mp", "<Cmd>GithubPreviewToggle<CR>", noremap = true, desc = "Preview Markdown" },
    },
    opts = {},
  },
}
