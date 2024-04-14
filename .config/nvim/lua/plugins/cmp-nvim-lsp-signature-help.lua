return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "nvim_lsp_signature_help" })
    opts.formatting = vim.tbl_deep_extend("force", opts.formatting, {
      source_names = {
        nvim_lsp_signature_help = "ʪ",
      },
    })
  end,
}
