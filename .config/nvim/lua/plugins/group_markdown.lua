return {
  {
    "lukas-reineke/headlines.nvim",
    ft = "markdown",
    opts = {
      markdown = { fat_headlines = false },
    },
    {
      "SidOfc/mkdx",
      ft = "markdown",
      init = function()
        vim.g["mkdx#settings"] = {
          checkbox = { toggles = { " ", "-", "X" } },
          insert_indent_mappings = 1, -- <c-t> to indent, <c-d> to unindent
          -- highlight = { enable = true },
          links = { conceal = 1 },
          map = { prefix = "<leader>m" },
          -- tab = { enable = 0 },
        }
      end,
      config = function()
        vim.keymap.set(
          "n",
          "<cr>",
          "<Plug>(mkdx-checkbox-prev-n)",
          { buffer = true, noremap = true, desc = "Toggle Checkbox" }
        )
      end,
    },
  },
}
