return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    opts = {
      silent = true,
      filter = function(bufnr)
        local excluded_filetypes = {
          "Avante",
          "AvanteInput",
          "DressingInput",
          "NvimTree",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
          "cmp",
          "codecompanion",
          "dashboard",
          "harpoon",
          "lazy",
          "lspinfo",
          "neoai-input",
          "snacks_picker_input",
          "starter",
        }

        return not vim.tbl_contains(excluded_filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr }))
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
        -- "<a-cr>",
        "<a-y>",
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
      -- conflicts with luasnip mapping
      -- {
      --   "<a-l>",
      --   function()
      --     require("neocodeium").accept_line()
      --   end,
      --   mode = "i",
      --   desc = "Codeium Accept Line",
      -- },
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
        "<a-e>",
        function()
          require("neocodeium").clear()
        end,
        mode = "i",
        desc = "Clear Codeium",
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = ":AvanteBuild",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "saghen/blink.cmp",
        opts_extend = { "sources.compat" },
        opts = {
          sources = {
            compat = {
              "avante_commands",
              "avante_mentions",
              "avante_files",
            },
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts_extend = { "file_types" },
        opts = {
          file_types = { "Avante" },
        },
        ft = { "markdown", "norg", "rmd", "org", "codecompanion", "Avante" },
      },
    },
    opts = {
      -- local ollama model {{{
      provider = "ollama",
      vendors = {
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          -- endpoint = "http://localhost:11434/api/generate",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "mistral-mike",
        },
      },
      -- }}}
      -- https://github.com/yetone/avante.nvim?tab=readme-ov-file#blinkcmp-users
      file_selector = { provider = "snacks" },
      -- auto_suggestions_provider = "gemini",
      -- mappings = {
      --   suggestion = {
      --     accept = "<a-y>",
      --     next = "<a-n>",
      --     prev = "<a-p>",
      --     dismiss = "<a-e>",
      --   },
      -- },
    },
    -- just change some highlights
    config = function(_, opts)
      require("avante").setup(opts)
      vim.cmd("hi link AvantePopupHint Comment")
      vim.cmd("hi link AvanteInlineHint Comment")
    end,
  },
}
