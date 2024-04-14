return {
  "kevinhwang91/nvim-bqf",
  dependencies = "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = "BufRead",
  config = function()
    require("bqf").setup({
      should_preview_cb = function(bufnr, _)
        return vim.api.nvim_buf_get_option(bufnr, "filetype") ~= "git"
      end,
    })
  end,
}
