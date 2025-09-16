return {
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
        jsonls = {},
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
      -- https://github.com/rickharris/dotfiles/blob/921c3b1ceec9e4f8939ceb24ff04ec55cbe32abc/dotfiles/.config/nvim/lua/plugins/nvim-lspconfig.lua
      -- TODO: Remove this when https://github.com/LazyVim/LazyVim/issues/5861 is
      -- fixed
      --
      -- Taken from
      -- https://github.com/iainlane/dotfiles/commit/1abe290bfe071b92a806eea62abadbab18ee63c3
      --
      -- A copy of LazyVim's setup function with one change (marked inline) to fix
      -- auto-fixing on neovim 0.11.
      setup = {
        eslint = function()
          local function get_client(buf)
            return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = LazyVim.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          -- Changed from upstream: check the version explicitly instead of
          -- looking for `vim.lsp._require`. Seems like that check stopped working
          -- with Neovim 0.11.
          if vim.fn.has("nvim-0.10") == 0 then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local pull_diagnostics =
                  vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id, false) })
                -- Older versions of the ESLint language server send push
                -- diagnostics rather than using pull. We support both for
                -- backwards compatibility.
                local push_diagnostics =
                  vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id, true) })
                if (#pull_diagnostics + #push_diagnostics) > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
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
  -- TODO: this broke - figure out the fix
  {
    "zapling/mason-lock.nvim",
    branch = "feat/support-mason2",
    opts = {},
    dependencies = { "mason-org/mason.nvim" },
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
  { "Sebastian-Nielsen/better-type-hover", opts = {} },
}
