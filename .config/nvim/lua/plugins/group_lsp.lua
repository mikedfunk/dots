---@param key nil|table<string>
---@param values table<string>
---@return table<string>
local function addTo(key, values)
  return vim.list_extend(key or {}, values)
end

return {
  -- TODO: not working
  -- {
  --   "nvimtools/none-ls.nvim",
  --   dependencies = { "mason.nvim", "davidmh/cspell.nvim" },
  --   opts = function(_, opts)
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       require("cspell").code_actions,
  --     })
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      -- vim.lsp.start({
      --   name = "contextive",
      --   cmd = { "Contextive.LanguageServer" },
      --   root_dir = vim.fs.dirname(vim.fs.find({ ".contextive" }, { upward = true })[1]),
      -- })
      -- vim.lsp.start({
      --   name = "semgrep",
      --   cmd = { "semgrep", "lsp" },
      --   root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
      -- })

      -- NOTE: This is only needed if you need to change options or you are
      -- using a local version of a language server. If it's installed with
      -- Mason, ensure_installed below is enough.
      -- NOTE: eslint is handled by a lazyvim extra in ../config/lazy.lua
      opts.servers = vim.tbl_deep_extend("force", opts.servers, {
        flow = {
          cmd = vim.fn.filereadable("./node_modules/.bin/flow") == 1 and { "npm", "exec", "flow", "lsp" }
            or { "npx", "flow", "lsp" },
          filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
        },
        phpactor = { enabled = false },
        -- snyk_ls = {
        --   init_options = {
        --     token = os.getenv("SNYK_TOKEN"),
        --     enableTrustedFoldersFeature = "false",
        --     enableTelemetry = "false",
        --     activateSnykCodeQuality = "true",
        --     organization = "leaf-saatchiart",
        --   },
        -- },
        tailwindcss = {
          -- https://www.reddit.com/r/neovim/comments/1c784zq/tailwindcss_unusable_inotify_max_events_does/l068l30/
          -- capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } },
          root_dir = require("lspconfig.util").root_pattern("tailwind.config.js"),
        },
        tsserver = {
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          single_file_support = false,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
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
        php = addTo(fmt.php, { "phpcbf", "php_cs_fixer" }),
        python = addTo(fmt.python, { "black" }),
        sql = addTo(fmt.sql, { "sqlfluff" }),
        svelte = addTo(fmt.svelte, { "rustywind" }),
        typescript = addTo(fmt.typescript, { "rustywind" }),
        typescriptreact = addTo(fmt.typescriptreact, { "rustywind" }),
        vue = addTo(fmt.vue, { "rustywind" }),
      })

      ---@type table<string, conform.FormatterUnit[]>
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters, {
        phpcbf = {
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
        sqlfluff = {
          prepend_args = { "--dialect", "mysql" },
        },
      })
    end,
  },
  {

    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lnt = opts.linters_by_ft

      return vim.tbl_deep_extend("force", opts, {
        linters_by_ft = {
          editorconfig = addTo(lnt.editorconfig, { "editorconfig-checker" }),
          gitcommit = addTo(lnt.gitcommit, { "gitlint" }),
          javascript = addTo(lnt.javascript, { "cspell" }),
          javascriptreact = addTo(lnt.javascriptreact, { "cspell" }),
          typescript = addTo(lnt.typescript, { "cspell" }),
          typescriptreact = addTo(lnt.typescriptreact, { "cspell" }),
          make = addTo(lnt.make, { "checkmake" }),
          php = addTo(lnt.php, { "phpstan", "phpcs", "cspell" }),
          python = addTo(lnt.python, { "isort" }),
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
      })
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = {
        enabled = true,
      },
      sign = {
        text = "",
        hl = "DiagnosticSignWarn",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    -- dependencies = {
    --   { "zapling/mason-lock.nvim", config = true }, -- doesn't work - error
    -- },
    opts = {
      ui = {
        border = "rounded",
      },
      -- TODO: empty this out. Instead, setup things in nvim-lint, conform,
      -- nvim-dap, and lspconfig. Then if they are not installed, automatically
      -- install them with these packages:
      --
      -- [ ] https://github.com/rshkarin/mason-nvim-lint
      -- [ ] https://github.com/LittleEndianRoot/mason-conform
      -- [X] https://github.com/williamboman/mason-lspconfig.nvim
      -- [X] https://github.com/jay-babu/mason-nvim-dap.nvim
      --
      -- Alternative that I don't like: https://github.com/Frostplexx/mason-bridge.nvim
      ensure_installed = {
        "biome",
        "black",
        "blade-formatter",
        "checkmake",
        "cspell",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "editorconfig-checker",
        "emmet-language-server",
        "gitlint",
        "isort",
        "json-lsp",
        "lemminx",
        "markdownlint",
        "php-cs-fixer",
        "prettierd",
        "ruff-lsp",
        "rustywind",
        "sqlfluff",
        "sqlls",
        "tailwindcss-language-server",
        "taplo",
        "yaml-language-server",
        -- "actionlint",
        -- "cbfmt",
        -- "contextive",
        -- "cucumber-language-server", -- https://github.com/tree-sitter/tree-sitter-typescript/issues/244
        -- "harper-ls", -- TODO: not in nvim-lspconfig yet
        -- "nginx-language-server",
        -- "snyk-ls",
      },
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  -- { "Wansmer/symbol-usage.nvim", event = "LspAttach", opts = { vt_position = "end_of_line" } }, -- buggy - breaks on dropbar
}
