return {
  {
    -- add some lualine components to display some more things in the statusline
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        -- main config for neocodeium AI completion. Nested under lualine because I also add a lualine component.
        "monkoose/neocodeium",
        event = "VeryLazy",
        opts = {
          silent = true,
          filter = function(bufnr)
            local excluded_filetypes = {
              "DressingInput",
              "NvimTree",
              "TelescopePrompt",
              "TelescopeResults",
              "alpha",
              "dashboard",
              "harpoon",
              "lazy",
              "lspinfo",
              "neoai-input",
              "starter",
            }

            if vim.tbl_contains(excluded_filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              return false
            end

            return true
          end,
          -- show_label = false,
        },
        dependencies = {
          {
            -- add AI section to which-key
            "folke/which-key.nvim",
            opts = { spec = { { "<leader>a", group = "+ai" } } },
          },
        },
        keys = {
          { "<leader>at", "<Cmd>NeoCodeium toggle<cr>", noremap = true, desc = "Toggle Codeium" },
          {
            "<a-cr>",
            function()
              require("neocodeium").accept()
            end,
            mode = "i",
            desc = "Codeium Accept",
          },
          {
            "<a-w>",
            function()
              require("neocodeium").accept_word()
            end,
            mode = "i",
            desc = "Codeium Accept Word",
          },
          {
            "<a-l>",
            function()
              require("neocodeium").accept_line()
            end,
            mode = "i",
            desc = "Codeium Accept Line",
          },
          {
            "<a-n>",
            function()
              require("neocodeium").cycle(1)
            end,
            mode = "i",
            desc = "Next Codeium Completion",
          },
          {
            "<a-p>",
            function()
              require("neocodeium").cycle(-1)
            end,
            mode = "i",
            desc = "Prev Codeium Completion",
          },
          {
            "<a-c>",
            function()
              require("neocodeium").clear()
            end,
            mode = "i",
            desc = "Clear Codeium",
          },
        },
      },
    },
    ---Add some lualine components
    ---@param opts LuaLineOpts
    opts = function(_, opts)
      local neocodeium_status_component = {
        LazyVim.config.icons.kinds.Codeium,
        -- function()
        --   -- return "󰌶" --  󱙺 󰌵 󱐋 ⚡ 󰲋 󰲌󰚩 
        --   -- local on = "󰲋"
        --   -- local off = "󰲌"
        --   -- local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
        --   -- return is_neocodeium_enabled and on or off
        -- end,
        color = function()
          local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          return {
            fg = is_neocodeium_enabled and LazyVim.ui.fg("Normal").fg or LazyVim.ui.fg("Comment").fg,
            -- fg = is_neocodeium_enabled and LazyVim.ui.fg("DiagnosticOk").fg or LazyVim.ui.fg("DiagnosticError").fg,
          }
        end,
        on_click = function()
          if package.loaded["neocodeium"] then
            vim.cmd("NeoCodeium toggle")
          end
        end,
        cond = function()
          return package.loaded["neocodeium"] ~= nil
        end,
      }

      table.insert(opts.sections.lualine_x, neocodeium_status_component)
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- { "echasnovski/mini.pick", opts = {} },
      { "echasnovski/mini.diff", opts = {} },
    },
    opts = {
      strategies = {
        -- chat = { adapter = "openai" },
        -- inline = { adapter = "openai" },
        -- agent = { adapter = "openai" },
        chat = { adapter = "anthropic" },
        inline = { adapter = "anthropic" },
        agent = { adapter = "anthropic" },
        -- chat = { adapter = "ollama" },
        -- inline = { adapter = "ollama" },
        -- agent = { adapter = "ollama" },
      },
    },
    diff = { provider = "mini_diff" },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    keys = {
      {
        "<Leader>ai",
        "<Cmd>CodeCompanionChat Toggle<CR>",
        mode = { "n", "v" },
        desc = "Toggle CodeCompanion Chat",
        noremap = true,
      },
      {
        "<Leader>ab",
        "<Cmd>CodeCompanion /buffer<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Buffer",
        noremap = true,
      },
      {
        "<Leader>ae",
        "<Cmd>CodeCompanion /explain<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Explain",
        noremap = true,
      },
      {
        "<Leader>aa",
        "<Cmd>CodeCompanionActions<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
        noremap = true,
      },
      {
        "<a-a>",
        "<Cmd>CodeCompanionActions<CR>",
        mode = "i",
        desc = "CodeCompanion Actions",
        noremap = true,
      },
    },
  },
  -- {
  --   "Bryley/neoai.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     {
  --       "folke/which-key.nvim",
  --       opts = { spec = { { "<leader>a", group = "+ai" } } },
  --     },
  --   },
  --   -- expects OPENAI_API_KEY env var to be set
  --   opts = {
  --     models = {
  --       {
  --         name = "openai",
  --         -- model = "gpt-3.5-turbo",
  --         model = "gpt-4",
  --         params = nil,
  --       },
  --     },
  --   },
  --   cmd = {
  --     "NeoAI",
  --     "NeoAIOpen",
  --     "NeoAIClose",
  --     "NeoAIToggle",
  --     "NeoAIContext",
  --     "NeoAIContextOpen",
  --     "NeoAIContextClose",
  --     "NeoAIInject",
  --     "NeoAIInjectCode",
  --     "NeoAIInjectContext",
  --     "NeoAIInjectContextCode",
  --   },
  --   keys = {
  --     { "<Leader>ai", "<cmd>NeoAIToggle<cr>", desc = "NeoAI Chat", noremap = true },
  --     { "<Leader>ac", "<cmd>NeoAIContext<cr>", desc = "NeoAI Context", noremap = true },
  --     { "<Leader>ac", "<cmd>'<,'>NeoAIContext<cr>", desc = "NeoAI Context", noremap = true, mode = "v" },
  --     { "<Leader>as", desc = "NeoAI Summarize", mode = "v" },
  --     { "<Leader>ag", desc = "NeoAI Commit Message" },
  --   },
  -- },
}
