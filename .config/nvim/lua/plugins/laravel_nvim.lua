return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "kevinhwang91/promise-async",
      {
        "nvim-telescope/telescope.nvim",
        opts = {
          defaults = {
            mappings = {
              i = {
                ["<Esc>"] = "close",
                ["<C-n>"] = function(bufnr)
                  require("telescope.actions").cycle_history_next(bufnr)
                end,
                ["<C-p>"] = function(bufnr)
                  require("telescope.actions").cycle_history_prev(bufnr)
                end,
                ["<C-j>"] = function(bufnr)
                  require("telescope.actions").move_selection_next(bufnr)
                end,
                ["<C-k>"] = function(bufnr)
                  require("telescope.actions").move_selection_previous(bufnr)
                end,
                ["<M-p>"] = function(bufnr)
                  require("telescope.actions").toggle_preview(bufnr)
                end,
              },
            },
          },
        },
      },
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            {
              "<leader>P",
              group = "+php",
              icon = "",
              cond = function()
                return vim.bo.ft == "php"
              end,
            },
          },
        },
      },
    },
    ft = { "php" },
    keys = {
      {
        "<leader>Pr",
        "<Cmd>Laravel routes<cr>",
        noremap = true,
        desc = "Laravel routes",
        ft = "php",
      },
    },
    opts = {
      lsp_server = vim.g.lazyvim_php_lsp,
      features = {
        route_info = { enable = true, view = "right" },
        model_info = { enable = false },
        override = { enable = false },
        -- pickers = { enable = true, provider = "fzf-lua" }, -- fzf-lua picker is broken - problem with preview
      },
    },
  },
}
