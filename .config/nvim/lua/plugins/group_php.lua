return {
  -- I don't need this - laravel_ls already provides most of this functionality
  -- {
  --   "adalessa/laravel.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-neotest/nvim-nio",
  --     {
  --       -- add AI section to which-key
  --       "folke/which-key.nvim",
  --       opts = { spec = { { "<leader>P", group = "+laravel" } } },
  --     },
  --   },
  --   ft = { "php", "blade" },
  --   event = { "BufEnter composer.json" },
  --   keys = {
  --     {
  --       "<leader>Pl",
  --       function()
  --         Laravel.pickers.laravel()
  --       end,
  --       desc = "Laravel: Picker",
  --     },
  --     {
  --       "<leader>Pa",
  --       function()
  --         Laravel.pickers.artisan()
  --       end,
  --       desc = "Laravel: Artisan Picker",
  --     },
  --     {
  --       "<leader>Pr",
  --       function()
  --         Laravel.pickers.routes()
  --       end,
  --       desc = "Laravel: Routes Picker",
  --     },
  --     {
  --       "<leader>Pm",
  --       function()
  --         Laravel.pickers.make()
  --       end,
  --       desc = "Laravel: Make Picker",
  --     },
  --     {
  --       "<leader>Pc",
  --       function()
  --         Laravel.pickers.commands()
  --       end,
  --       desc = "Laravel: Custom Commands Picker",
  --     },
  --     {
  --       "<leader>Po",
  --       function()
  --         Laravel.pickers.resources()
  --       end,
  --       desc = "Laravel: Resources Picker",
  --     },
  --     {
  --       "<leader>Ph",
  --       function()
  --         Laravel.run("artisan docs")
  --       end,
  --       desc = "Laravel: Documentation",
  --     },
  --     {
  --       "<leader>Pt",
  --       function()
  --         Laravel.commands.run("actions")
  --       end,
  --       desc = "Laravel: Code Actions",
  --     },
  --     {
  --       "<leader>Pu",
  --       function()
  --         Laravel.commands.run("hub")
  --       end,
  --       desc = "Laravel: Artisan Hub",
  --     },
  --     {
  --       "<leader>Pp",
  --       function()
  --         Laravel.commands.run("command_center")
  --       end,
  --       desc = "Laravel: Command Center",
  --     },
  --     {
  --       "<c-g>",
  --       function()
  --         Laravel.commands.run("view:finder")
  --       end,
  --       desc = "Laravel: View Finder",
  --     },
  --     {
  --       "gf",
  --       function()
  --         if Laravel.app("gf").cursorOnResource() then
  --           return "<cmd>lua Laravel.commands.run('gf')<cr>"
  --         end
  --         return "gf"
  --       end,
  --       expr = true,
  --       noremap = true,
  --       desc = "Laravel: Go to resource",
  --     },
  --   },
  --   opts = {
  --     features = {
  --       pickers = {
  --         provider = "snacks", -- telescope | fzf-lua | snacks | ui.select
  --       },
  --     },
  --     extensions = {
  --       route_info = { enable = true, view = "right" },
  --     },
  --   },
  -- },
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
