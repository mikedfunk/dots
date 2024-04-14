return {
  "akinsho/bufferline.nvim",
  opts = {
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
      -- symbols-outline.nvim
      offsets = {
        {
          filetype = "Outline",
          highlight = "PanelHeading",
          padding = 1,
          text = "Symbols",
        },
      },
    },
  },
}
