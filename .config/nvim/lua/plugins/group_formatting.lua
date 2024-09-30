return {
  -- TODO: I can't get this to work. It can't find any mason packages. I'll
  -- have to add these in mason ensure_installed instead. I'm setting
  -- everything up to run in the order it requires. 🤷 last checked 2024-09-21
  -- {
  --   "LittleEndianRoot/mason-conform",
  --   dependencies = {
  --     "stevearc/conform.nvim",
  --     dependencies = "williamboman/mason.nvim",
  --   },
  --   opts = {},
  -- },
  {
    "stevearc/conform.nvim",
    -- NOTE: workaround: see above comment about mason-conform which I would rather use
    dependencies = {
      "williamboman/mason.nvim",
      opts_extend = { "ensure_installed" },
      opts = {
        ensure_installed = {
          "black",
        },
      },
    },
    opts_extend = {
      "formatters_by_ft.python",
      "formatters_by_ft.php",
      "formatters.phpcbf.prepend_args",
    },
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        timeout_ms = 30000,
        async = true,
      },
      formatters_by_ft = {
        python = { "black" },
        php = { "phpcbf" },
      },
      formatters = {
        phpcbf = {
          -- ALWAYS use local version because it is tightly coupled to the
          -- default _rules_ it comes with.
          command = "./vendor/bin/phpcbf",
          prepend_args = {
            "--cache",
            "--warning-severity=3", -- fix warnings up to severity 3
            -- "--warning-severity=0", -- do not fix warnings
            "-d",
            "memory_limit=100m",
            "-d",
            "xdebug.mode=off",
            "-d",
            "zend.enable_gc=0",
          },
        },
        php_cs_fixer = {
          -- command = "php -d zend.enable_gc=0 -d xdebug.mode=off -d memory_limit=100m php-cs-fixer",
          cwd = function(self, ctx)
            return require("conform.util").root_file({ ".php-cs-fixer.php" })(self, ctx)
          end,
          require_cwd = true,
        },
        prettier = {
          command = "prettier",
          cwd = function(self, ctx)
            return require("conform.util").root_file({
              -- O_O
              ".prettierrc",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.json",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.mjs",
              ".prettierrc.cjs",
              "prettier.config.js",
              "prettier.config.mjs",
              "prettier.config.cjs",
              ".prettierrc.toml",
            })(self, ctx)
          end,
          require_cwd = true,
        },
        stylua = {
          require_cwd = true,
        },
      },
    },
    -- opts = function(_, opts) ---@diagnostic disable-line assign-type-mismatch
    --   local default_opts = {
    --     timeout_ms = 30000,
    --     async = true,
    --   }
    --   opts = vim.tbl_deep_extend("force", opts, {
    --   })
    -- end,
    -- opts = function(_, opts)
    --   -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    --   local format_opts = {
    --     timeout_ms = 30000,
    --     async = true,
    --   }
    --   opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts or {}, format_opts)
    --   opts.formatters_by_ft.python = opts.formatters_by_ft.python or {}
    --   table.insert(opts.formatters_by_ft.python, "black") ---@diagnostic disable-line: param-type-mismatch
    --   opts.formatters_by_ft.php = { "php_cs_fixer", "phpcbf" }
    --
    --   -- fix some formatters
    --   opts.formatters.phpcbf =
    --     vim.tbl_deep_extend("force", opts.formatters.phpcbf or {}, { ---@diagnostic disable-line: param-type-mismatch
    --       -- ALWAYS use local version because it is tightly coupled to the
    --       -- default _rules_ it comes with.
    --       command = "./vendor/bin/phpcbf",
    --       prepend_args = {
    --         "--cache",
    --         "--warning-severity=3", -- fix warnings up to severity 3
    --         -- "--warning-severity=0", -- do not fix warnings
    --         "-d",
    --         "memory_limit=100m",
    --         "-d",
    --         "xdebug.mode=off",
    --         "-d",
    --         "zend.enable_gc=0",
    --       },
    --     })
    --
    --   print(vim.inspect(opts.formatters.phpcbf))
    --
    --   opts.formatters.php_cs_fixer = vim.tbl_deep_extend(
    --     "force",
    --     opts.formatters.php_cs_fixer or {}, ---@diagnostic disable-line: param-type-mismatch
    --     {
    --       -- command = "php -d zend.enable_gc=0 -d xdebug.mode=off -d memory_limit=100m php-cs-fixer",
    --       cwd = require("conform.util").root_file({ ".php-cs-fixer.php" }),
    --       require_cwd = true,
    --     }
    --   )
    --
    --   opts.formatters.prettier =
    --     vim.tbl_deep_extend("force", opts.formatters.prettier or {}, { ---@diagnostic disable-line: param-type-mismatch
    --       command = "prettier",
    --       cwd = require("conform.util").root_file({
    --         -- O_O
    --         ".prettierrc",
    --         ".prettierrc.yaml",
    --         ".prettierrc.yml",
    --         ".prettierrc.json",
    --         ".prettierrc.json5",
    --         ".prettierrc.js",
    --         ".prettierrc.mjs",
    --         ".prettierrc.cjs",
    --         "prettier.config.js",
    --         "prettier.config.mjs",
    --         "prettier.config.cjs",
    --         ".prettierrc.toml",
    --       }),
    --       require_cwd = true,
    --     })
    -- end,
  },
}
