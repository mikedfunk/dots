return {
  {
    "neovim/nvim-lspconfig",
    opts_extend = {
      "servers.snyk_ls.filetypes",
      "servers.emmet_language_server.filetypes",
    },
    opts = {
      codelens = { enabled = true },
      servers = {
        biome = {},
        contextive = {
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern(".contextive")(startpath)
          end,
          autostart = false, -- to use this LS, :LspStop then :LspStart contextive
        },
        cssls = {
          filetypes = { "css" }, -- replace filetypes
        },
        cssmodules_ls = {},
        cucumber_language_server = {},
        -- flow = {},
        emmet_language_server = {
          filetypes = { "javascript" }, -- add more filetypes
        },
        -- golangci_lint_ls = {}, -- lazyvim go extra already has gopls that does this fine
        jsonls = {},
        lemminx = {},
        -- lsp_ai = {}, -- TODO: This is currently installed via cargo. Put this in Mason once it's available there.
        snyk_ls = {
          filetypes = { "php" }, -- add more filetypes
          init_options = {
            token = os.getenv("SNYK_TOKEN"),
            enableTrustedFoldersFeature = "false",
            enableTelemetry = "false",
            activateSnykCodeQuality = "true",
            organization = "leaf-saatchiart",
          },
          autostart = false, -- to use this LS: :LspStart snyk_ls
        },
        -- phpactor = {},
        somesass_ls = {},
        sqlls = {},
        tailwindcss = {
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "tailwind.config.cts",
              "tailwind.config.mts"
            )(startpath)
          end,
        },
        taplo = {},
        vtsls = {
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json")(startpath)
          end,
          single_file_support = false,
        },
        yamlls = {},
        zk = {}, -- because marksman crashes a lot
      },
    },
  },
  -- get a hierarchical tree of references with :FunctionReferences (only if lsp feature is supported)
  { "lafarr/hierarchy.nvim", event = "LspAttach", opts = {} },
  -- {
  --   "kitagry/bqls.nvim",
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("lspconfig").bqls.setup({
  --       init_options = {
  --         project_id = "BIGQUERY_PROJECT_ID",
  --       },
  --     })
  --   end,
  -- },
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
    "zapling/mason-lock.nvim",
    opts = {},
    dependencies = { "williamboman/mason.nvim" },
  },
  { "antosha417/nvim-lsp-file-operations", opts = {} },
  -- {
  --   "rachartier/tiny-inline-diagnostic.nvim",
  --   priority = 1000, -- needs to be loaded in first
  --   config = function()
  --     require("tiny-inline-diagnostic").setup()
  --     vim.diagnostic.config({ virtual_text = false })
  --   end,
  -- },
  -- Buggy and slow when lots of usages. Breaks on dropbar.
  -- Overlaps with LSP codelens references
  -- {
  --   "Wansmer/symbol-usage.nvim",
  --   enabled = false,
  --   event = "LspAttach",
  --   opts = { vt_position = "end_of_line" },
  -- },
}
