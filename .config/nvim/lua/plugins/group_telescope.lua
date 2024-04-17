return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "debugloop/telescope-undo.nvim",
      keys = {
        { "<Leader>U", "<Cmd>Telescope undo<CR>", desc = "Telescope Undo" },
      },
    },
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
        },
      },
    })

    require("telescope").load_extension("undo")
  end,
}
