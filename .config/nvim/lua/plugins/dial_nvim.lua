return {
  "monaqa/dial.nvim",
  opts = function()
    local opts = require("lazyvim.plugins.extras.editor.dial").opts()
    local augend = require("dial.augend")

    local checkboxes = augend.constant.new({
      elements = { "[ ]", "[X]", "[-]" },
      word = false,
      cyclic = true,
    })

    table.insert(opts.groups.markdown, checkboxes)

    return opts
  end,
}
