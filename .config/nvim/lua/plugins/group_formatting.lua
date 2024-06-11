---@param key nil|table<string>
---@param values table<string>
---@return table<string>
local function addTo(key, values)
  return vim.list_extend(key or {}, values)
end

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
      opts = {
        ensure_installed = {
          "blade-formatter",
          "black",
          "php-cs-fixer",
          "rustywind",
        },
      },
    },
    ---@class ConformOpts
    opts = function(_, opts)
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      opts.format = vim.tbl_deep_extend("force", opts.format, {
        timeout_ms = 20000,
      })

      -- what a pain in the ass. If I don't use list_extend here, it will
      -- _override_ the previous list, not append to it. This list was already
      -- added to by extras.prettier.
      local fmt = opts.formatters_by_ft
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft, {
        blade = addTo(fmt.blade, { "blade-formatter", "rustywind" }),
        javascript = addTo(fmt.javascript, { "rustywind" }),
        javascriptreact = addTo(fmt.javascriptreact, { "rustywind" }),
        python = addTo(fmt.python, { "black" }),
        svelte = addTo(fmt.svelte, { "rustywind" }),
        typescript = addTo(fmt.typescript, { "rustywind" }),
        typescriptreact = addTo(fmt.typescriptreact, { "rustywind" }),
        vue = addTo(fmt.vue, { "rustywind" }),
      })

      ---@type table<string, conform.FormatterUnit[]>
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters, {
        phpcbf = {
          command = "./vendor/bin/phpcbf",
          prepend_args = {
            "--cache",
            "--warning-severity=3",
            "-d",
            "memory_limit=100m",
            "-d",
            "xdebug.mode=off",
          },
        },
        php_cs_fixer = {
          cwd = require("conform.util").root_file({ ".php-cs-fixer.php" }),
          require_cwd = true,
        },
        prettier = {
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
        },
      })
    end,
  },
}
