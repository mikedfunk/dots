return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb",
    "tyru/open-browser.vim",
    "folke/which-key.nvim",
  },
  config = function()
    vim.cmd("command! -nargs=1 Browse OpenBrowser <args>") -- allow GBrowse to work with open-browser.nvim instead of netrw
  end,
}
