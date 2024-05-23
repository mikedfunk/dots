---@param key nil|table<string>
---@param values table<string>
---@return table<string>
local function addTo(key, values)
  return vim.list_extend(key or {}, values)
end

return {
  {
    -- automatically install nvim-lint packages that are configured
    "rshkarin/mason-nvim-lint",
    opts = function()
      -- add some missing packages :/
      require("mason-nvim-lint.mapping").nvimlint_to_package =
        vim.tbl_deep_extend("force", require("mason-nvim-lint.mapping").nvimlint_to_package, {
          checkmake = "checkmake",
          ["editorconfig-checker"] = "editorconfig-checker",
          gitlint = "gitlint",
        })
    end,
    dependencies = {
      "mfussenegger/nvim-lint",
      dependencies = "williamboman/mason.nvim",
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.fish = nil -- There is no such nvim-lint linter as "fish"
      local lnt = opts.linters_by_ft

      return vim.tbl_deep_extend("force", opts, {
        linters_by_ft = {
          editorconfig = addTo(lnt.editorconfig, { "editorconfig-checker" }),
          gitcommit = addTo(lnt.gitcommit, { "gitlint" }),
          javascript = addTo(lnt.javascript, { "cspell" }),
          javascriptreact = addTo(lnt.javascriptreact, { "cspell" }),
          typescript = addTo(lnt.typescript, { "cspell" }),
          typescriptreact = addTo(lnt.typescriptreact, { "cspell" }),
          markdown = addTo(lnt.markdown, { "markdownlint" }),
          make = addTo(lnt.make, { "checkmake" }),
          php = addTo(lnt.php, { "phpstan", "phpcs", "cspell" }),
          sql = addTo(lnt.sql, { "sqlfluff" }),
        },
        linters = {
          phpstan = {
            args = {
              "analyze",
              "--error-format=json",
              "--no-progress",
              "--memory-limit=200M",
              "--level=9",
            },
          },
          phpcs = {
            cmd = "./vendor/bin/phpcs",
            -- This doesn't work because the parser expects stdin :/
            -- stdin = false,
            args = {
              -- https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/phpcs.lua
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
      })
    end,
  },
}
