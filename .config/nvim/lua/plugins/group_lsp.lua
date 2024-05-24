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
        contextive = {
          root_dir = require("lspconfig.util").root_pattern(".contextive"),
        },
        cucumber_language_server = {},
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
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  -- { "Wansmer/symbol-usage.nvim", event = "LspAttach", opts = { vt_position = "end_of_line" } }, -- buggy - breaks on dropbar
}
