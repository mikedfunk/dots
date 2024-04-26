return {
  {
    "folke/noice.nvim",
    dependencies = {
      { "smjonas/inc-rename.nvim", config = true },
    },
    opts = {
      ---@type NoicePresets
      presets = {
        lsp_doc_border = true,
        inc_rename = true,
      },
      ---@class NoiceConfigViews
      -- views = {
      --   notify = {
      --     backend = "notify_send",
      --   },
      -- },
      -- https://github.com/folke/noice.nvim/discussions/364
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "lsp",
            find = "snyk",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
