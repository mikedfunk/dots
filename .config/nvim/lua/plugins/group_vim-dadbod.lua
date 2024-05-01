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
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-completion",
        init = function()
          vim.g.db_ui_use_nerd_fonts = 1
          vim.g.db_ui_show_database_icon = 1
          vim.g.db_ui_use_nvim_notify = 1

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
