-- vim: set foldmethod=marker:

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
          ["markdownlint-cli2"] = "markdownlint-cli2",
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
      -- fix phpcs linter to allow --stdin-path=... {{{
      require("lint.linters.phpcs").parser = function(output, _)
        local severities = {
          ERROR = vim.diagnostic.severity.ERROR,
          WARNING = vim.diagnostic.severity.WARN,
        }
        local bin = "phpcs"

        if vim.trim(output) == "" or output == nil then
          return {}
        end

        if not vim.startswith(output, "{") then
          -- vim.notify(output)
          return {}
        end

        local decoded = vim.json.decode(output)
        local diagnostics = {}
        -- the fix: {{{
        -- local messages = decoded['files']['STDIN']['messages']
        local messages = {}

        for _, values in pairs(decoded["files"]) do
          messages = values["messages"]
          break
        end
        -- }}}

        for _, msg in ipairs(messages or {}) do
          table.insert(diagnostics, {
            lnum = msg.line - 1,
            end_lnum = msg.line - 1,
            col = msg.column - 1,
            end_col = msg.column - 1,
            message = msg.message,
            code = msg.source,
            source = bin,
            severity = assert(severities[msg.type], "missing mapping for severity " .. msg.type),
          })
        end

        return diagnostics
      end
      -- }}}

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
          php = addTo(lnt.php, { "phpstan", "cspell" }),
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
            args = {
              -- works together with stdin-path fix above
              function()
                return "--stdin-path=" .. vim.fn.expand("%")
              end,
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
