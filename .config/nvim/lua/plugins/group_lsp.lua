return {
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
        biome = {},
        cssls = {},
        jsonls = {},
        docker_compose_language_service = {},
        dockerls = {},
        emmet_language_server = {},
        lemminx = {},
        ruff_lsp = {},
        sqlls = {},
        taplo = {},
        yamlls = {},
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
      -- Empty this out. Instead, setup things in nvim-lint, conform,
      -- nvim-dap, and lspconfig. Then if they are not installed, automatically
      -- install them with these packages:
      --
      -- [X] https://github.com/rshkarin/mason-nvim-lint
      -- [X] https://github.com/LittleEndianRoot/mason-conform
      -- [X] https://github.com/williamboman/mason-lspconfig.nvim
      -- [X] https://github.com/jay-babu/mason-nvim-dap.nvim
      --
      -- Alternative that I don't like: https://github.com/Frostplexx/mason-bridge.nvim
      -- ensure_installed = {
      --   "biome",
      --   "black",
      --   "blade-formatter",
      --   "checkmake",
      --   "cspell",
      --   "css-lsp",
      --   "docker-compose-language-service",
      --   "dockerfile-language-server",
      --   "editorconfig-checker",
      --   "emmet-language-server",
      --   "gitlint",
      --   "isort",
      --   "json-lsp",
      --   "lemminx",
      --   "markdownlint",
      --   "php-cs-fixer",
      --   "prettierd",
      --   "ruff-lsp",
      --   "rustywind",
      --   "sqlfluff",
      --   "sqlls",
      --   "tailwindcss-language-server",
      --   "taplo",
      --   "yaml-language-server",
      --   -- "actionlint",
      --   -- "cbfmt",
      --   -- "contextive",
      --   -- "cucumber-language-server", -- https://github.com/tree-sitter/tree-sitter-typescript/issues/244
      --   -- "harper-ls", -- TODO: not in nvim-lspconfig yet
      --   -- "nginx-language-server",
      --   -- "snyk-ls",
      -- },
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  -- { "Wansmer/symbol-usage.nvim", event = "LspAttach", opts = { vt_position = "end_of_line" } }, -- buggy - breaks on dropbar
}
