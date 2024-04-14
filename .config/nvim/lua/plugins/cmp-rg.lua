return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "lukas-reineke/cmp-rg",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "rg" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = {
        rg = "",
      },
    })
  end,
}
