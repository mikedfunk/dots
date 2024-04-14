return {
  "tpope/vim-fugitive",
  -- ft = { 'fugitive' },
  -- cmd = fugitive_commands,
  -- keys = 'y<c-g>',
  dependencies = {
    "tpope/vim-rhubarb",
    "tyru/open-browser.vim",
    "folke/which-key.nvim",
  },
  config = function()
    vim.cmd("command! -nargs=1 Browse OpenBrowser <args>") -- allow GBrowse to work with open-browser.nvim instead of netrw
    -- vim.api.nvim_set_keymap('n', 'y<c-g>', ':<C-U>call setreg(v:register, fugitive#Object(@%))<CR>', { noremap = true, silent = true }) -- work around an issue preventing lazy loading with y<c-g> from working

    require("which-key").register({ g = { G = { "<Cmd>Git<CR>", "Fugitive" } } }, { prefix = "<Leader>" })

    require("which-key").register({
      o = { name = "Toggle..." },
      ["<c-g>"] = { name = "Copy path" },
    }, { prefix = "y" })
  end,
}
