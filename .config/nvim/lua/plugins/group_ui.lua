return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        options = {
          persist_buffer_sort = true,
          hover = { enabled = true },
          sort_by = "insert_after_current",
          always_show_bufferline = true,
          style_preset = require("bufferline").style_preset.no_italic,
          separator_style = "slant",
          groups = {
            items = {
              require("bufferline.groups").builtin.pinned:with({ icon = "" }),
            },
          },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        border = "rounded",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      -- ---@type NoicePresets
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      lualine_bold = true, -- bold headers for each section header
      day_brightness = 0.15, -- high contrast but colorful
    },
  },
  -- {
  --   "echasnovski/mini.starter",
  --   dependencies = { "rubiin/fortune.nvim", config = true },
  --   opts = function(_, opts)
  --     local fortune = require("fortune").get_fortune()
  --     opts.footer = table.concat(fortune, "\n")
  --   end,
  -- },
}
