return {
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      bullet = { icons = { "•", "", "⬩", "⋄" } },
      checkbox = { unchecked = { icon = "󰄱 " }, checked = { icon = " " } },
      -- checkbox = { unchecked = { icon = "□ " }, checked = { icon = "▣ " } },
      -- checkbox = { unchecked = { icon = "󰄱 " }, checked = { icon = " " } },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },
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
    "zk-org/zk-nvim",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = { spec = { { "<leader>z", group = "+zettelkasten" } } },
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
        opts = {
          spec = {
            { "<leader>m", group = "+markdown" },
            { "<leader>m'", desc = "Toggle quote" },
            { "<leader>m/", desc = "Italic" },
            { "<leader>m=", desc = "next checkbox" },
            { "<leader>m[", desc = "Promote header" },
            { "<leader>m]", desc = "Demote header" },
            { "<leader>m`", desc = "Inline code" },
            { "<leader>mb", desc = "Bold" },
            { "<leader>mI", desc = "Quickfix doc" },
            { "<leader>mi", desc = "Generate or update TOC" },
            { "<leader>mj", desc = "Jump to header" },
            { "<leader>mk", desc = "Toggle to keyboard" },
            { "<leader>mL", desc = "Quickfix links" },
            { "<leader>ms", desc = "Strikethrough" },
            { "<leader>mt", desc = "Toggle checkbox" },

            { "<leader>ml", group = "+list" },
            { "<leader>mll", desc = "Toggle list" },
            { "<leader>mln", desc = "Wrap link" },
            { "<leader>mlt", desc = "Toggle checklist" },
          },
        },
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
