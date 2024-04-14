return {
  "hrsh7th/nvim-cmp",
  dependencies = { "ray-x/cmp-treesitter" },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "treesitter" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = {
        treesitter = "",
      },
    })
  end,
}
