return {
  "hrsh7th/nvim-cmp",
  dependencies = { "chrisgrieser/cmp-nerdfont" },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "nerdfont" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = { nerdfont = "" },
    })
  end,
}
