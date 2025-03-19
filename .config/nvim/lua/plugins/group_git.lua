return {
  -- {
  --   "folke/snacks.nvim",
  --   opts = {
  --     git = { enabled = false },
  --   },
  -- },
  {
    "tpope/vim-fugitive",
    dependencies = {
      "folke/which-key.nvim",
      -- "tpope/vim-rhubarb",
      -- "tyru/open-browser.vim",
    },
    -- config = function()
    --   vim.cmd("command! -nargs=1 Browse OpenBrowser <args>") -- allow GBrowse to work with open-browser.nvim instead of netrw
    -- end,
  },
  -- this is only used for shortcuts in git interactive rebase
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
  -- usage:
  -- :DiffviewFileHistory % (log of current file)
  -- :DiffviewFileHistory (log of current repo)
  -- :DiffviewOpen (show all modified files)
  {
    "sindrets/diffview.nvim",
    lazy = false, -- avoid probs with git mergetool
    -- event = "VeryLazy",
    opts = {
      default = {
        disable_diagnostics = false,
      },
      view = {
        merge_tool = {
          disable_diagnostics = false,
          winbar_info = true,
        },
      },
      enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
    },
  },
  {
    "rhysd/committia.vim",
    ft = { "gitcommit", "gitrebase" },
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
      -- { "<Leader>gB", "<Cmd>GitConflictChooseBoth<CR>", desc = "Resolve both conflict" },
      { "<Leader>gn", "<Cmd>GitConflictChooseNone<CR>", desc = "Resolve none conflict" },
      { "<Leader>gq", "<Cmd>GitConflictListQf<CR>", desc = "List conflicts" },
      { "<Leader>gr", "<Cmd>GitConflictRefresh<CR>", desc = "Refresh conflicts" },
      { "[x", "<Cmd>GitConflictPrevConflict<CR>", desc = "Previous conflict" },
      { "]x", "<Cmd>GitConflictNextConflict<CR>", desc = "Next conflict" },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        default_mappings = false,
        disable_diagnostics = true,
      })
    end,
  },
}
