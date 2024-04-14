return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "andersevenrud/cmp-tmux",
      branch = "main",
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "tmux" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = {
        tmux = "",
      },
    })
  end,
}
