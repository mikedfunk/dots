return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "monkoose/neocodeium",
        event = "VeryLazy",
        opts = {
          silent = true,
        },
        keys = {
          {
            "<c-g>",
            function()
              require("neocodeium").accept()
            end,
            mode = "i",
            desc = "Codeium Accept",
          },
          {
            "<c-;>",
            function()
              require("neocodeium").cycle(1)
            end,
            mode = "i",
            desc = "Next Codeium Completion",
          },
          {
            "<c-,>",
            function()
              require("neocodeium").cycle(-1)
            end,
            mode = "i",
            desc = "Prev Codeium Completion",
          },
          {
            "<c-x>",
            function()
              require("neocodeium").clear()
            end,
            mode = "i",
            desc = "Clear Codeium",
          },
        },
      },
    },
    opts = function(_, opts)
      local neocodeium_status_component = {
        function()
          return ""
        end,
        color = function()
          local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium.options").options.enabled
          local colors = require("tokyonight.colors").setup()

          return {
            fg = is_neocodeium_enabled and colors.green or colors.red,
          }
        end,
        on_click = function()
          if package.loaded["neocodeium"] then
            vim.cmd("NeoCodeium toggle")
          end
        end,
      }

      table.insert(opts.sections.lualine_x, neocodeium_status_component)
    end,
  },
  {
    "Bryley/neoai.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    -- expects OPENAI_API_KEY env var to be set
    opts = {
      models = {
        {
          name = "openai",
          -- model = "gpt-3.5-turbo",
          model = "gpt-4",
          params = nil,
        },
      },
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<Leader>ai", "<cmd>NeoAIToggle<cr>", desc = "NeoAI Chat", noremap = true },
      { "<Leader>ac", "<cmd>NeoAIContext<cr>", desc = "NeoAI Context", noremap = true },
      { "<Leader>ac", "<cmd>NeoAIContext<cr>", desc = "NeoAI Context", noremap = true, mode = "v" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>a"] = { name = "AI" },
      },
    },
  },
}
