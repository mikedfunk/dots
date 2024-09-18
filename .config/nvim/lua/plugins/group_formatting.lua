return {
  -- TODO: I can't get this to work. It can't find any mason packages. I'll
  -- have to add these in mason ensure_installed instead. I'm setting
  -- everything up to run in the order it requires. 🤷
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
      opts = { ensure_installed = {
        "black",
      } },
    },
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts or {}, { timeout_ms = 20000 })
      opts.formatters_by_ft.python = opts.formatters_by_ft.python or {}
      table.insert(opts.formatters_by_ft.python, "black")
      opts.formatters_by_ft.php = { "phpcbf", "php_cs_fixer" }

      -- fix some formatters
      opts.formatters.phpcbf = {
        command = "./vendor/bin/phpcbf",
        prepend_args = {
          "--cache",
          "--warning-severity=3",
          "-d",
          "memory_limit=100m",
          "-d",
          "xdebug.mode=off",
        },
      }

      opts.formatters.php_cs_fixer = {
        cwd = require("conform.util").root_file({ ".php-cs-fixer.php" }),
        require_cwd = true,
      }

      opts.formatters.prettier = {
        cwd = require("conform.util").root_file({
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
        }),
        require_cwd = true,
      }
    end,
  },
}
