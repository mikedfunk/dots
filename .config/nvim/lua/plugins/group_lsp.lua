return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers, {
        flow = {},
        tsserver = {
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          single_file_support = false,
          -- enabled = vim.fs.find({ "jsconfig.json", "tsconfig.json" }, { path = vim.fn.expand("%"), upward = true })[1]
          --   ~= nil,
        },
        tailwindcss = {
          root_dir = require("lspconfig.util").root_pattern("tailwind.config.js"),
          -- enabled = vim.fs.find({ "tailwind.config.js" }, { path = vim.fn.expand("%"), upward = true })[1] ~= nil,
        },
        phpactor = { enabled = false },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false, -- easy way to get configured formatters in lualine before saving
    opts = {
      format = {
        timeout_ms = 20000,
      },
      formatters_by_ft = {
        javascript = {
          "eslint", -- eslint_d just will not use local eslint. complains about rules
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
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        php = {
          "phpcs",
          "cspell",
        },
        javascript = {
          "eslint", -- eslint_d just will not use local eslint. complains about rules
          "cspell",
        },
        sql = {
          "sqlfluff",
        },
      },
      linters = {
        phpcs = {
          -- This doesn't work because the parser expects stdin :/
          -- stdin = false,
          args = {
            "-q",
            "--report=json",
            "--cache",
            "--warning-severity=3",
            "-d",
            "memory_limit=100M",
            "-d",
            "xdebug.mode=off",
            "-",
          },
        },
      },
    },
  },
}
