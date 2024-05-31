return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
        workspace = {
          didChangeWatchedFiles = { dynamicRegistration = false },
        },
      })

      -- NOTE: set up all servers we will use and do *not* put them in
      -- `ensure_installed`. `mason-lspconfig.nvim` will automatically install
      -- them.
      --
      -- NOTE: eslint lsp is handled by a lazyvim extra in ../config/lazy.lua
      opts.servers = vim.tbl_deep_extend("force", opts.servers, {
        biome = {},
        -- contextive = {
        --   root_dir = require("lspconfig.util").root_pattern(".contextive"),
        -- },
        cssls = {},
        cucumber_language_server = {},
        flow = {},
        phpactor = { enabled = false },
        emmet_language_server = {},
        jsonls = {},
        lemminx = {},
        ruff_lsp = {},
        -- snyk_ls = {
        --   init_options = {
        --     token = os.getenv("SNYK_TOKEN"),
        --     enableTrustedFoldersFeature = "false",
        --     enableTelemetry = "false",
        --     activateSnykCodeQuality = "true",
        --     organization = "leaf-saatchiart",
        --   },
        -- },
        sqlls = {},
        tailwindcss = {
          root_dir = require("lspconfig.util").root_pattern("tailwind.config.js"),
        },
        taplo = {},
        vtsls = {
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          single_file_support = false,
        },
        yamlls = {},
      })
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = { enabled = true },
      sign = {
        text = "",
        hl = "DiagnosticSignWarn",
      },
    },
  },
  {
    -- "zapling/mason-lock.nvim",
    "mikedfunk/mason-lock.nvim",
    config = true,
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  -- Buggy and slow when lots of usages. Breaks on dropbar.
  -- { "Wansmer/symbol-usage.nvim", event = "LspAttach", opts = { vt_position = "end_of_line" } },
}
