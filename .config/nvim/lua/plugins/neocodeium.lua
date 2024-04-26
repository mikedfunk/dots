return {
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
  {
    "nvim-lualine/lualine.nvim",
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
}
