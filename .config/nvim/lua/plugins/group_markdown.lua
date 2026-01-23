return {
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "gitcommit" },
    init = function()
      vim.g.bullets_enable_in_empty_buffers = false
      local bullets_filetypes = { "markdown", "text", "gitcommit", "scratch" }
      vim.g.bullets_enabled_file_types = bullets_filetypes
      vim.g.bullets_checkbox_markers = table.concat({
        " ", -- unchecked
        " ", -- partial: < 33%
        " ", -- partial: > 33%, < 66%
        " ", -- partial: > 66%, < 100%
        "x", -- checked
      }, "")

      vim.g.bullets_set_mappings = 0 -- re-do mappings

      -- if I don't put this in an autocmd then it will enable these mappings
      -- for every filetype :/ It's not respecting the ft filter above.
      vim.api.nvim_create_autocmd("Filetype", {
        group = vim.api.nvim_create_augroup("mike_bullets_mappings", { clear = true }),
        pattern = bullets_filetypes,
        callback = function()
          vim.keymap.set(
            "i",
            "<cr>",
            "<Plug>(bullets-newline)",
            { noremap = true, buffer = true, desc = "New bullet line" }
          )
          vim.keymap.set("i", "<C-cr>", "<cr>", { noremap = true, buffer = true, desc = "Regular CR" })

          vim.keymap.set(
            "n",
            "o",
            "<Plug>(bullets-newline)",
            { noremap = true, buffer = true, desc = "New bullet line" }
          )
          vim.keymap.set("n", ">>", "<Plug>(bullets-demote)", { noremap = true, buffer = true, desc = "Demote bullet" })
          vim.keymap.set(
            "n",
            "<<",
            "<Plug>(bullets-promote)",
            { noremap = true, buffer = true, desc = "Promote bullet" }
          )

          vim.keymap.set("v", ">", "<Plug>(bullets-demote)", { noremap = true, buffer = true, desc = "Demote bullet" })
          vim.keymap.set(
            "v",
            "<",
            "<Plug>(bullets-promote)",
            { noremap = true, buffer = true, desc = "Promote bullet" }
          )
        end,
        desc = "bullets.nvim mappings",
      })
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
    -- config = function()
    --   require("otter").activate()
    -- end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      templates = { folder = "Templates" },
      daily_notes = { folder = "" },
      frontmatter = { enabled = false },
      workspaces = {
        {
          name = "Notes",
          path = "~/Notes",
        },
      },
      footer = {
        format = "{{backlinks}} backlinks",
      },
    },
    keys = {
      {
        "<a-N>",
        "<Cmd>Obsidian new_from_template<cr>",
        mode = "n",
        noremap = true,
        buffer = true,
        desc = "Obsidian New From Template",
      },
      {
        "<a-T>",
        "<Cmd>Obsidian template<cr>",
        mode = "n",
        noremap = true,
        buffer = true,
        desc = "Obsidian Apply Template",
      },
      {
        "<a-D>",
        "<Cmd>Obsidian today<cr>",
        mode = "n",
        noremap = true,
        buffer = true,
        desc = "Obsidian Apply Template",
      },
    },
  },
}
