return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- pulled from typescript extras. Why? So I could enable flow LSP instead
    -- of typescript when relevant
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
    end
  end,
}
