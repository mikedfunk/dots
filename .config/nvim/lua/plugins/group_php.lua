return {
  {
    "adalessa/laravel.nvim",
    -- TODO: There is some bug with execution on v4.x, need to fix
    tag = "v3.3.0",
    -- enabled = false,
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
              -- cond = function()
              --   return vim.bo.ft == "php"
              -- end,
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
      lsp_server = vim.g.lazyvim_php_lsp or "phpactor",
      features = {
        route_info = { enable = true, view = "right" },
        model_info = { enable = false },
        override = { enable = false },
        -- pickers = { enable = true, provider = "fzf-lua" }, -- fzf-lua picker is broken - problem with preview
      },
    },
  },
  {
    "gbprod/phpactor.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      {
        "mason-org/mason.nvim",
        opts_extend = { "ensure_installed" },
        opts = {
          ensure_installed = { "phpactor" },
        },
      },
    },
    filetypes = { "php" },
    keys = {
      { "<Leader>rm", "<Cmd>PhpActor context_menu<CR>", buffer = true, noremap = true, desc = "PHP Refactor Menu" },
    },
    cmd = { "PhpActor" },
    opts = {
      install = {
        bin = vim.fn.stdpath("data") .. "/mason/packages/phpactor/phpactor.phar",
        -- phpactor requires php 8.1+
        -- php_bin = vim.fn.executable("mise") == 1
        --     and table.concat(vim.fn.systemlist({ "mise", "where", "php-brew", "8.4" }), "") .. "/bin/php"
        --   or "php",
        -- path = vim.fn.stdpath("data") .. "/mason/packages/phpactor",
        -- composer_bin = vim.fn.executable("mise") == 1
        --     and table.concat(vim.fn.systemlist({ "mise", "where", "php-brew", "8.4" }), "") .. "/bin/composer"
        --   or "composer",
      },
      lspconfig = { enabled = false },
    },
  },
  {
    "jdrupal-dev/code-refactor.nvim",
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "php",
    },
    opts = {},
    keys = {
      { "<Leader>rt", "<Cmd>CodeActions all<CR>", buffer = true, noremap = true, desc = "Treesitter Refactor Menu" },
    },
  },
}
