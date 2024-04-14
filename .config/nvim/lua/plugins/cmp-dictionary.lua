return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "uga-rosa/cmp-dictionary",
      config = function()
        require("cmp_dictionary").setup({
          paths = { "/usr/share/dict/words" },
          -- dic = { ["*"] = "/usr/share/dict/words" },
        })
      end,
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "dictionary", keyword_length = 2, max_item_count = 3 })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = {
        dictionary = "",
      },
    })
  end,
}
