return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "mikedfunk/cmp-jira",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },
  }, -- fork to use basic auth, which is apparently needed for Jira cloud
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "cmp_jira" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = {
        cmp_jira = "",
      },
    })
  end,
}
