return {
  {
    "whatyouhide/vim-textobj-xmlattr",
    ft = {
      "jsx",
      "javascriptreact",
      "typescriptreact",
      "html",
      "xml",
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      useDefaultKeymaps = true,
      disabledKeymaps = { "gc", "gw" },
    },
  },
}
