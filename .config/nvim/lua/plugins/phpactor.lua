return {
  {
    "gbprod/phpactor.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      {
        "williamboman/mason.nvim",
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
        php_bin = vim.fn.executable("asdf") == 1
            and table.concat(vim.fn.systemlist({ "asdf", "where", "php", "8.2.12" }), "") .. "/bin/php"
          or "php",
        path = vim.fn.stdpath("data") .. "/mason/packages/phpactor",
        composer_bin = vim.fn.executable("asdf") == 1
          and table.concat(vim.fn.systemlist({ "asdf", "where", "php", "8.2.12" }) or "composer", "")
            .. "/.composer/vendor/bin/composer",
      },
      lspconfig = { enabled = false },
    },
  },
}
