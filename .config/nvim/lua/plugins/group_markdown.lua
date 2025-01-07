return {
  { "bullets-vim/bullets.vim", ft = "markdown" },
  {
    "monaqa/dial.nvim",
    opts = function()
      local opts = require("lazyvim.plugins.extras.editor.dial").opts()
      local augend = require("dial.augend")

      local checkboxes = augend.constant.new({
        -- pattern_regexp = "\\[.]\\s", -- TODO: doesn't work
        elements = { "[ ]", "[x]", "[-]" },
        word = false,
        cyclic = true,
      })

      table.insert(opts.groups.markdown, checkboxes)
    end,
    keys = {
      { "<CR>", "<Cmd>norm <C-a><CR>", mode = "n", noremap = true, desc = "Dial" },
    },
  },
}
