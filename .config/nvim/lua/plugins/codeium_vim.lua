return {
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    -- event = "InsertEnter",
    init = function()
      vim.g.codeium_disable_bindings = 1
    end,
    config = function()
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-;>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local codeium_status_component = {
        function()
          return ""
        end,
        color = function()
          local is_codeium_enabled = vim.fn.exists("*codeium#Enabled") == 1 and vim.fn["codeium#Enabled"]()
          local colors = require("tokyonight.colors").setup()

          return {
            fg = is_codeium_enabled and colors.green or colors.red,
          }
        end,
        on_click = function()
          if vim.fn.exists("*codeium#Enabled") == 0 then
            return
          end

          if vim.fn["codeium#Enabled"]() then
            vim.cmd("CodeiumDisable")
          else
            vim.cmd("CodeiumEnable")
          end
        end,
      }

      table.insert(opts.sections.lualine_x, codeium_status_component)
    end,
  },
}
