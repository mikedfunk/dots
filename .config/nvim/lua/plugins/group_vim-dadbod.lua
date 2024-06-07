-- TODO: replace with SQL extra https://github.com/LazyVim/LazyVim/pull/1741
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nvim_notify = 1
    end,
    keys = {
      { "<leader>D", "<Cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.right, {
        title = "Database",
        ft = "dbui",
        pinned = true,
        width = 0.3,
        open = function()
          vim.cmd("DBUI")
        end,
      })

      table.insert(opts.bottom, {
        title = "DB Query Result",
        ft = "dbout",
        size = { height = 0.5 },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-completion",
        init = function()
          vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("dadbod_cmp", { clear = true }),
            pattern = { "sql", "mysql", "plsql" },
            callback = function()
              require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
            end,
            desc = "dadbod completion",
          })
        end,
      },
    },
  },
}
