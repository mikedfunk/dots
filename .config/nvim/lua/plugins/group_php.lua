return {
  -- NOTE: This is the old version, there is some bug where latest 4.x isn't working
  -- TODO: after rebuilding my neovim config, this isn't working either :/
  -- {
  --   "adalessa/laravel.nvim",
  --   tag = "v3.3.0",
  --   ft = { "php", "json" },
  --   dependencies = { "kevinhwang91/promise-async" },
  --   opts = {
  --     lsp_server = vim.g.lazyvim_php_lsp or "phpactor",
  --     features = {
  --       -- I only use this for route info
  --       route_info = { enable = true, view = "right" },
  --       model_info = { enable = false },
  --       override = { enable = false },
  --       pickers = { enable = false },
  --     },
  --   },
  -- },
  -- NOTE: I use this for:
  -- - route info in virtual text next to controller actions
  -- - I have completion enabled for blade templates but I don't really use it
  -- - composer.json version virtual text for new versions, etc.
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-neotest/nvim-nio",
      {
        "saghen/blink.cmp",
        opts_extend = { "sources.compat" },
        opts = {
          sources = {
            compat = {
              "laravel",
            },
          },
        },
      },
    },
    ft = { "php", "json" },
    cmd = { "Laravel" },
    opts = {
      extensions = {
        command_center = { enable = false },
        completion = { enable = true },
        composer_dev = { enable = true },
        composer_info = { enable = true },
        diagnostic = { enable = false },
        dump_server = { enable = false },
        model_info = { enable = false },
        override = { enable = false },
        route_info = { enable = true, view = "right" },
        tinker = { enable = false },
      },
      lsp_server = vim.g.lazyvim_php_lsp or "phpactor",
      features = {
        pickers = { enable = false },
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
