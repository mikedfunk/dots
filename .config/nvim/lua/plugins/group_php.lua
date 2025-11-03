return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      {
        "saghen/blink.cmp",
        opts_extend = { "sources.default" },
        opts = {
          sources = {
            default = {
              "laravel",
            },
            providers = {
              laravel = {
                name = "laravel",
                module = "blink.compat.source",
                -- async = true,
                score_offset = 95, -- higher than lsp priority
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
            },
          },
        },
      },
    },
    ft = { "php", "json" },
    cmd = { "Laravel" },
    -- event = { "VeryLazy" },
    keys = {
      {
        "<leader>Pr",
        function()
          Laravel.pickers.routes()
        end,
        desc = "Laravel: Open Routes Picker",
      },
      -- {
      --   "<leader>Po",
      --   function()
      --     Laravel.pickers.resources()
      --   end,
      --   desc = "Laravel: Open Resources Picker",
      -- },
    },
    ---@type LaravelOptions
    opts = {
      extensions = {
        command_center = { enable = false },
        -- composer_dev = { enable = false },
        -- composer_info = { enable = false },
        dump_server = { enable = false },
        mcp = { enable = false },
        model_info = { enable = false },
        override = { enable = false },
        route_info = { enable = true, view = "right" },
        tinker = { enable = false },
      },
      lsp_server = vim.g.lazyvim_php_lsp or "phpactor",
      features = {
        pickers = {
          enable = true,
          provider = "snacks", -- "snacks | telescope | fzf-lua | ui-select"
        },
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
}
