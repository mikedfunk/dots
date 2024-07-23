return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
      "tyru/open-browser.vim",
      "folke/which-key.nvim",
    },
    config = function()
      vim.cmd("command! -nargs=1 Browse OpenBrowser <args>") -- allow GBrowse to work with open-browser.nvim instead of netrw
    end,
  },
  {
    "tpope/vim-git",
    ft = "gitrebase",
    config = function()
      vim.keymap.set("n", "I", "<Cmd>Pick<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "R", "<Cmd>Reword<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "E", "<Cmd>Edit<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "S", "<Cmd>Squash<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "F", "<Cmd>Fixup<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "D", "<Cmd>Drop<cr>", { buffer = true, noremap = true })

      -- need to test these (visual mode)
      vim.keymap.set("v", "I", ":'<,'>Pick<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "R", ":'<,'>Reword<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "E", ":'<,'>Edit<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "S", ":'<,'>Squash<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "F", ":'<,'>Fixup<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "D", ":'<,'>Drop<cr>", { buffer = true, noremap = true })
    end,
  },
  {
    "rhysd/committia.vim",
    ft = "gitcommit",
  },
  {
    "FabijanZulj/blame.nvim",
    opts = {},
    keys = {
      { "<leader>gb", "<Cmd>BlameToggle<CR>", noremap = true, desc = "Toggle Blame" },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    lazy = false,
    keys = {
      { "<Leader>go", "<Cmd>GitConflictChooseOurs<CR>", desc = "Resolve ours conflict" },
      { "<Leader>gt", "<Cmd>GitConflictChooseTheirs<CR>", desc = "Resolve theirs conflict" },
      { "<Leader>gB", "<Cmd>GitConflictChooseBoth<CR>", desc = "Resolve both conflict" },
      { "<Leader>gn", "<Cmd>GitConflictChooseNone<CR>", desc = "Resolve none conflict" },
      { "<Leader>gq", "<Cmd>GitConflictListQf<CR>", desc = "List conflicts" },
      { "[x", "<Cmd>GitConflictPrevConflict<CR>", desc = "Previous conflict" },
      { "]x", "<Cmd>GitConflictNextConflict<CR>", desc = "Next conflict" },
    },
    -- opts = {
    --   default_mappings = false,
    --   disable_diagnostics = true,
    --   list_opener = "Trouble quickfix",
    -- },
    opts = function(_, opts)
      -- vim.api.nvim_create_autocmd("User", {
      --   group = vim.api.nvim_create_augroup("git_conflict", { clear = true }),
      --   pattern = "GitConflictDetected",
      --   command = "GitConflictListQf",
      --   desc = "List conflicts",
      -- })

      return vim.tbl_deep_extend("force", opts, {
        default_mappings = false,
        disable_diagnostics = true,
        -- list_opener = "Trouble quickfix",
      })
    end,
  },
}
