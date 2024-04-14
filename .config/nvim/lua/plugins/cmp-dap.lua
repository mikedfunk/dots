return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "rcarriga/cmp-dap",
      config = function()
        require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
          sources = {
            { name = "dap" },
          },
        })
      end,
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    -- table.insert(opts.sources, { name = "dap" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = { dap = "" },
    })
  end,
}
