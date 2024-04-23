return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "debugloop/telescope-undo.nvim",
        keys = {
          { "<Leader>U", "<Cmd>Telescope undo<CR>", desc = "Telescope Undo" },
        },
      },
      -- {
      --   "someone-stole-my-name/yaml-companion.nvim",
      --   dependencies = {
      --     "neovim/nvim-lspconfig",
      --     "nvim-lua/plenary.nvim",
      --   },
      --   config = true,
      -- },
    },
    opts = function(_, opts)
      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        undo = {
          mappings = {
            i = {
              ["<cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
      })

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<Esc>"] = "close",
            -- flip these mappings - defaults are counter-intuitive
            ["<C-n>"] = require("telescope.actions").cycle_history_next,
            ["<C-p>"] = require("telescope.actions").cycle_history_prev,

            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      })

      require("telescope").load_extension("undo")
      -- require("telescope").load_extension("yaml_schema")
    end,
  },
}
