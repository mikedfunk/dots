return {
  -- like Codeium but with any back-end and much slower
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- fix: without this the highlight keeps getting cleared
    init = function()
      vim.api.nvim_create_autocmd({ "LspAttach" }, {
        group = vim.api.nvim_create_augroup("mike_minuet_virtual_text", {}),
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "MinuetVirtualText", { link = "Comment" })
        end,
        desc = "Minuet virtual text highlight fix",
      })
    end,
    opts = {
      -- debounce = 0,
      -- throttle = 0,
      blink = { enable_auto_complete = false },
      -- provider = "gemini",

      -- claude provider {{{
      provider = "claude",
      -- provider_options = {
      --   claude = { model = "claude-sonnet-4-20250514" }, -- default: claude-3-5-haiku-20241022
      -- },
      -- }}}

      -- ollama provider {{{
      -- provider = "openai_fim_compatible",
      -- n_completions = 1,
      -- context_window = 512,
      -- provider_options = {
      --   openai_fim_compatible = {
      --     api_key = "TERM",
      --     name = "Ollama",
      --     stream = true,
      --     end_point = "http://localhost:11434/v1/completions",
      --     model = "qwen2.5-coder:7b", -- takes 2-3 seconds to respond
      --     -- model = "qwen2.5-coder:3b", -- takes 1-2 seconds to respond
      --     -- model = "qwen2.5-coder:1.5b", -- takes 0.3-1 seconds to respond
      --     optional = {
      --       max_tokens = 56,
      --       top_p = 0.9,
      --     },
      --   },
      -- },
      -- }}}

      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = {
          "Avante",
          "AvanteInput",
          "DressingInput",
          "NvimTree",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
          "cmp",
          "codecompanion",
          "dap-repl",
          "dashboard",
          "harpoon",
          "lazy",
          "lspinfo",
          "neoai-input",
          "snacks_picker_input",
          "starter",
        },
        show_on_completion_menu = true,
        keymap = {
          -- accept = "<a-y>",
          accept_line = "<a-y>",
          prev = "<a-p>",
          next = "<a-n>",
          dismiss = "<a-e>",
        },
      },
    },
    -- config = function(_, opts)
    --   require("minuet").setup(opts)
    --   vim.api.nvim_set_hl(0, "MinuetVirtualText", { link = "Comment" })
    --   require("minuet.virtualtext")
    -- end,
  },
  -- {
  --   "monkoose/neocodeium",
  --   event = "VeryLazy",
  --   dependencies = {
  --     {
  --       -- add AI section to which-key
  --       "folke/which-key.nvim",
  --       opts = { spec = { { "<leader>a", group = "+ai" } } },
  --     },
  --   },
  --   keys = {
  --     { "<leader>at", "<Cmd>NeoCodeium toggle<cr>", noremap = true, desc = "Toggle Codeium" },
  --     {
  --       -- "<a-cr>",
  --       "<a-y>",
  --       function()
  --         require("neocodeium").accept()
  --       end,
  --       mode = "i",
  --       desc = "Codeium Accept",
  --     },
  --     {
  --       "<a-w>",
  --       function()
  --         require("neocodeium").accept_word()
  --       end,
  --       mode = "i",
  --       desc = "Codeium Accept Word",
  --     },
  --     -- conflicts with luasnip mapping
  --     -- {
  --     --   "<a-l>",
  --     --   function()
  --     --     require("neocodeium").accept_line()
  --     --   end,
  --     --   mode = "i",
  --     --   desc = "Codeium Accept Line",
  --     -- },
  --     {
  --       "<a-n>",
  --       function()
  --         require("neocodeium").cycle(1)
  --       end,
  --       mode = "i",
  --       desc = "Next Codeium Completion",
  --     },
  --     {
  --       "<a-p>",
  --       function()
  --         require("neocodeium").cycle(-1)
  --       end,
  --       mode = "i",
  --       desc = "Prev Codeium Completion",
  --     },
  --     {
  --       "<a-e>",
  --       function()
  --         require("neocodeium").clear()
  --       end,
  --       mode = "i",
  --       desc = "Clear Codeium",
  --     },
  --   },
  --   opts = {
  --     silent = true,
  --     filetypes = {
  --       Avante = false,
  --       AvanteInput = false,
  --       DressingInput = false,
  --       NvimTree = false,
  --       TelescopePrompt = false,
  --       TelescopeResults = false,
  --       alpha = false,
  --       cmp = false,
  --       codecompanion = false,
  --       ["dap-repl"] = false,
  --       dashboard = false,
  --       harpoon = false,
  --       lazy = false,
  --       lspinfo = false,
  --       ["neoai-input"] = false,
  --       snacks_picker_input = false,
  --       starter = false,
  --     },
  --     -- show_label = false,
  --   },
  -- },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   build = ":AvanteBuild",
  --   opts = {
  --     -- mcphub replaces these
  --     -- disabled_tools = {
  --     --   "list_files",
  --     --   "search_files",
  --     --   "read_file",
  --     --   "create_file",
  --     --   "rename_file",
  --     --   "delete_file",
  --     --   "create_dir",
  --     --   "rename_dir",
  --     --   "delete_dir",
  --     --   "bash",
  --     -- },
  --     -- system_prompt = function()
  --     --   local hub = require("mcphub").get_hub_instance()
  --     --   if hub == nil then
  --     --     return
  --     --   end
  --     --   return hub:get_active_servers_prompt()
  --     -- end,
  --     -- custom_tools = function()
  --     --   return { require("mcphub.extensions.avante").mcp_tool() }
  --     -- end,
  --     behaviour = {
  --       -- auto_suggestions = true,
  --       enable_cursor_planning_mode = true,
  --     },
  --     -- https://github.com/yetone/avante.nvim?tab=readme-ov-file#blinkcmp-users
  --     file_selector = { provider = "snacks" },
  --     provider = "gemini",
  --     -- gemini = {
  --     --   model = "gemini/gemini-2.0-flash-exp", -- not yet available in avante. :AvanteModels
  --     -- },
  --     -- moved to .lazy.lua in some projects
  --     -- rag_service = {
  --     --   provider = "gemini",
  --     --   enabled = true,
  --     -- },
  --     -- auto_suggestion_provider = "gemini",
  --     -- mappings = {
  --     --   suggestion = {
  --     --     accept = "<a-y>",
  --     --     next = "<a-n>",
  --     --     prev = "<a-p>",
  --     --     dismiss = "<a-e>",
  --     --   },
  --     -- },
  --     -- suggestion = {
  --     --   debounce = 1000,
  --     --   throttle = 1000,
  --     -- },
  --     -- local ollama model {{{
  --     -- auto_suggestions_provider = "ollama",
  --     -- provider = "ollama",
  --     -- vendors = {
  --     --   ollama = {
  --     --     __inherited_from = "openai",
  --     --     api_key_name = "",
  --     --     -- endpoint = "http://localhost:11434/api/generate",
  --     --     endpoint = "http://127.0.0.1:11434/v1",
  --     --     model = "qwen2.5-coder:7b",
  --     --   },
  --     -- },
  --     -- }}}
  --   },
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     -- {
  --     --   "ravitemer/mcphub.nvim",
  --     --   build = "npm install -g mcp-hub@latest",
  --     --   dependencies = { "nvim-lua/plenary.nvim" },
  --     --   cmd = "MCPHub",
  --     --   opts = {},
  --     -- },
  --     {
  --       "saghen/blink.cmp",
  --       dependencies = { "Kaiser-Yang/blink-cmp-avante" },
  --       opts = {
  --         sources = {
  --           per_filetype = { AvanteInput = { "avante" } },
  --           providers = {
  --             avante = {
  --               module = "blink-cmp-avante",
  --               name = "Avante",
  --               -- opts = {},
  --             },
  --           },
  --         },
  --       },
  --     },
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts_extend = { "file_types" },
  --       opts = {
  --         file_types = { "Avante" },
  --       },
  --       ft = { "markdown", "norg", "rmd", "org", "codecompanion", "Avante" },
  --     },
  --   },
  --   -- just change some highlights
  --   config = function(_, opts)
  --     require("avante").setup(opts)
  --     vim.cmd("hi link AvantePopupHint Comment")
  --     vim.cmd("hi link AvanteInlineHint Comment")
  --   end,
  -- },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     {
  --       "saghen/blink.cmp", -- complete @ and / commands
  --       opts = {
  --         sources = { per_filetype = { codecompanion = "codecompanion" } },
  --       },
  --     },
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     { "echasnovski/mini.diff", opts = {} },
  --     -- { "echasnovski/mini.pick", opts = {} },
  --   },
  --   opts = {
  --     strategies = {
  --       -- chat = { adapter = "openai" },
  --       -- inline = { adapter = "openai" },
  --       -- agent = { adapter = "openai" },
  --       chat = { adapter = "anthropic" },
  --       inline = { adapter = "anthropic" },
  --       agent = { adapter = "anthropic" },
  --       -- chat = { adapter = "ollama" },
  --       -- inline = { adapter = "ollama" },
  --       -- agent = { adapter = "ollama" },
  --     },
  --   },
  --   diff = { provider = "mini_diff" },
  --   cmd = {
  --     "CodeCompanion",
  --     "CodeCompanionChat",
  --     "CodeCompanionActions",
  --   },
  --   keys = {
  --     {
  --       "<Leader>ai",
  --       "<Cmd>CodeCompanionChat Toggle<CR>",
  --       mode = { "n", "v" },
  --       desc = "Toggle CodeCompanion Chat",
  --       noremap = true,
  --     },
  --     {
  --       "<Leader>ab",
  --       "<Cmd>CodeCompanion /buffer<CR>",
  --       mode = { "n", "v" },
  --       desc = "CodeCompanion Buffer",
  --       noremap = true,
  --     },
  --     {
  --       "<Leader>ae",
  --       "<Cmd>CodeCompanion /explain<CR>",
  --       mode = { "n", "v" },
  --       desc = "CodeCompanion Explain",
  --       noremap = true,
  --     },
  --     {
  --       "<Leader>aa",
  --       "<Cmd>CodeCompanionActions<CR>",
  --       mode = { "n", "v" },
  --       desc = "CodeCompanion Actions",
  --       noremap = true,
  --     },
  --     {
  --       "<a-a>",
  --       "<Cmd>CodeCompanionActions<CR>",
  --       mode = "i",
  --       desc = "CodeCompanion Actions",
  --       noremap = true,
  --     },
  --   },
  -- },
}
