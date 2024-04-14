return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "folke/tokyonight.nvim",
  },
  event = "VimEnter",
  opts = {
    handle = {
      highlight = "PmenuSel",
    },
    excluded_filetypes = {
      "neo-tree-popup",
    },
  },
}
