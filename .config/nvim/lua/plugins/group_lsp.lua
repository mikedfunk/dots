return {
  -- TODO: trying to use this to add macos arm64 version of laravel-ls, but can't get it to work yet
  -- {
  --   "mason-org/mason.nvim",
  --   opts = {
  --     registries = {
  --       "lua:~/.local/share/nvim/mason-registry",
  --       "github:mason-org/mason-registry",
  --     },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    -- TODO: not working
    opts_extend = {
      "servers.snyk_ls.filetypes",
      "servers.emmet_language_server.filetypes",
    },
    ---@class PluginLspOpts
    opts = {
      codelens = { enabled = true },
      servers = {
        apex_ls = {
          apex_jar_path = vim.fn.stdpath("data") .. "/mason/share/apex-language-server/apex-jorje-lsp.jar",
          apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
          apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
        },
        biome = {},
        -- copilot = {},
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
        denols = {
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern("deno.json")(startpath)
          end,
        },
        eslint = { enabled = vim.fn.executable("eslint") == 1 },
        -- flow = {},
        emmet_language_server = {
          filetypes = { "javascript" }, -- add more filetypes
        },
        groovyls = {},
        -- harper_ls = {}, -- annoying grammar checker that usually reports false positives in code
        jsonls = {
          -- TODO: trying to fix this: Problems loading reference 'vscode://schemas/settings/machine': Unable to load schema from 'vscode://schemas/settings/machine': MethodNotFound.
          -- settings = {
          --   json = {
          --     schemas = require("schemastore").json.schemas({
          --       replace = {
          --         ["devcontainer.json"] = "https://raw.githubusercontent.com/devcontainers/spec/refs/heads/main/schemas/devContainer.base.schema.json",
          --       },
          --     }),
          --     validate = { enable = true },
          --   },
          -- },
        },
        -- TODO: mason doesn't recognize arm64 build so I installed with mise. Switch when available.
        laravel_ls = { mason = false },
        lemminx = {},
        -- lsp_ai = {},
        ---@see https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/snyk_ls.lua
        ---@see https://github.com/snyk/snyk-ls#configuration-1
        snyk_ls = {
          -- TODO: this is not merging with existing config
          -- filetypes = { "php" }, -- add more filetypes
          filetypes = {
            "go",
            "gomod",
            "javascript",
            "typescript",
            "json",
            "python",
            "requirements",
            "helm",
            "yaml",
            "terraform",
            "terraform-vars",
            "php",
          },
          -- TODO: I can't get this to merge properly with neoconf
          init_options = {
            token = os.getenv("SNYK_TOKEN"), -- docs say it will auto read the env var but it doesn't work :/
            enableTrustedFoldersFeature = "false",
            enableTelemetry = "false",
            organization = "leaf-saatchiart",
          },
          -- BUG: with autostart false it doesn't apply any of the config above
          -- autostart = false, -- to use this LS, :LspStart snyk_ls
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
          -- single_file_support = false, -- deprecated
          workspace_required = true,
        },
        yamlls = {},
        zk = {}, -- because marksman crashes a lot
      },
    },
  },
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
    event = "LspAttach",
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
    branch = "feat/support-mason2", -- TODO: when are they going to merge this?
    opts = {},
    dependencies = { "mason-org/mason.nvim" },
  },
  -- {
  --   "antosha417/nvim-lsp-file-operations",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   event = "LspAttach",
  --   opts = {},
  --   init = function()
  --     local lspconfig = require("lspconfig")
  --
  --     -- Set global defaults for all servers
  --     lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  --       capabilities = vim.tbl_deep_extend(
  --         "force",
  --         vim.lsp.protocol.make_client_capabilities(),
  --         -- returns configured operations if setup() was already called
  --         -- or default operations if not
  --         require("lsp-file-operations").default_capabilities()
  --       ),
  --     })
  --   end,
  -- },
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
  -- {
  --   "Sebastian-Nielsen/better-type-hover",
  --   ft = { "typescript", "typescriptreact" },
  --   opts = {},
  -- },
  -- get a hierarchical tree of references with :FunctionReferences (only if lsp feature is supported)
  -- { "lafarr/hierarchy.nvim", event = "LspAttach", opts = {} },
  -- { "m-demare/hlargs.nvim", opts = {} },
}
