return {
  "stevearc/conform.nvim",
  lazy = false, -- easy way to get configured formatters in lualine before saving
  opts = {
    format = {
      timeout_ms = 20000,
    },
    formatters_by_ft = {
      javascript = {
        "eslint_d",
        "prettier",
      },
      php = {
        "phpcbf",
        "php_cs_fixer",
      },
      python = {
        "black",
      },
      sql = {
        "sqlfluff",
      },
    },
    formatters = {
      phpcbf = {
        prepend_args = {
          "--cache",
          "--warning-severity=3",
          "-d",
          "memory_limit=100M",
          "-d",
          "xdebug.mode=off",
        },
      },
      php_cs_fixer = {
        condition = function(ctx)
          return vim.fs.find({ ".php-cs-fixer.php" }, { path = ctx.filename, upward = true })[1]
        end,
      },
      sqlfluff = {
        prepend_args = {
          "--dialect",
          "mysql",
        },
      },
    },
  },
}
