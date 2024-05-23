return {
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    },
  },
  {
    "smjonas/live-command.nvim",
    event = "VeryLazy",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
  },
  {
    "anuvyklack/fold-preview.nvim",
    event = "VeryLazy",
    opts = {
      auto = 400,
      border = "rounded",
      default_keybindings = false,
    },
  },
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {
      ignore_filetypes = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "starter",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = { hide_dotfiles = false },
        use_libuv_file_watcher = true,
      },
    },
  },
  { "wsdjeg/vim-fetch" }, -- go to file including line number e.g. stack trace
  {
    "smjonas/live-command.nvim",
    cmd = "Norm",
    opts = {
      commands = {
        Norm = { cmd = "norm" },
      },
    },
  },
  {
    "ziontee113/icon-picker.nvim",
    dependencies = "stevearc/dressing.nvim",
    cmd = { "IconPickerYank", "IconPickerInsert", "IconPickerNormal" },
    opts = { disable_legacy_commands = true },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      useDefaultKeymaps = true,
      disabledKeymaps = { "gc", "gw", "ai", "ii", "aI", "iI" },
    },
  },
  { "michaeljsmith/vim-indent-object" },
  {
    "echasnovski/mini.indentscope",
    opts = {
      mappings = {
        object_scope = "ic",
        object_scope_with_border = "iC",
      },
    },
  },
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

            ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
      })

      require("telescope").load_extension("undo")
      -- require("telescope").load_extension("yaml_schema")
    end,
  },
  { "fpob/nette.vim", event = "VimEnter" },
  { "martinda/Jenkinsfile-vim-syntax", event = "VimEnter" },
  { "aklt/plantuml-syntax", event = "VimEnter" },
  { "jwalton512/vim-blade", event = "VimEnter" },
  { "tpope/vim-cucumber", event = "VimEnter" },
  { "neoclide/vim-jsx-improve", ft = { "javascriptreact", "typescriptreact" } },
}
