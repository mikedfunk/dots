return {
  -- {
  --   "whatyouhide/vim-textobj-xmlattr",
  --   ft = {
  --     "jsx",
  --     "javascriptreact",
  --     "typescriptreact",
  --     "html",
  --     "xml",
  --   },
  -- },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      useDefaultKeymaps = true,
      disabledKeymaps = { "gc", "gw", "ai", "ii", "aI", "iI" },
    },
  },
  { "michaeljsmith/vim-indent-object" },
  {
    "echasnovski/mini.indentscope",
    opts = {
      mappings = {
        object_scope = "ic",
        object_scope_with_border = "iC",
      },
    },
  },
}
