return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  -- event = "InsertEnter",
  init = function()
    vim.g.codeium_disable_bindings = 1
  end,
  keys = {
    {
      "<m-tab>",
      function()
        return vim.fn["codeium#Accept"]()
      end,
      desc = "Codeium Accept",
      mode = "i",
      noremap = true,
      expr = true,
    },
    {
      "<m-]>",
      function()
        return vim.fn["codeium#CycleCompletions"](1)
      end,
      desc = "Next Codeium Completion",
      mode = "i",
      noremap = true,
      expr = true,
    },
    {
      "<m-[>",
      function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end,
      desc = "Prev Codeium Completion",
      mode = "i",
      noremap = true,
      expr = true,
    },
    {
      "<m-x>",
      function()
        return vim.fn["codeium#Clear"]()
      end,
      desc = "Codeium Clear",
      mode = "i",
      noremap = true,
      expr = true,
    },
    {
      "<m-i>",
      function()
        return vim.fn["codeium#Complete"]()
      end,
      desc = "Codeium Complete",
      mode = "i",
      noremap = true,
      expr = true,
    },
    {
      "<Leader>cO",
      function()
        if vim.fn["codeium#Enabled"]() == true then
          vim.cmd("CodeiumDisable")
        else
          vim.cmd("CodeiumEnable")
        end
      end,
      desc = "Toggle Codeium",
    },
  },
  -- config = function()
  --   vim.keymap.set("i", "<m-tab>", vim.fn["codeium#Accept"], { noremap = true, expr = true, desc = "Codeium Accept" })
  --   vim.keymap.set("i", "<m-]>", function()
  --     return vim.fn["codeium#CycleCompletions"](1)
  --   end, { noremap = true, expr = true, desc = "Next Codeium Completion" })
  --   vim.keymap.set("i", "<m-[>", function()
  --     return vim.fn["codeium#CycleCompletions"](-1)
  --   end, { noremap = true, expr = true, desc = "Prev Codeium Completion" })
  --   vim.keymap.set("i", "<m-x>", vim.fn["codeium#Clear"], { noremap = true, expr = true, desc = "Codeium Clear" })
  --   vim.keymap.set("i", "<m-i>", vim.fn["codeium#Complete"], { noremap = true, expr = true, desc = "Codeium Complete" })
  --
  --   require("which-key").register({
  --     cO = {
  --       function()
  --         if vim.fn["codeium#Enabled"]() == true then
  --           vim.cmd("CodeiumDisable")
  --         else
  --           vim.cmd("CodeiumEnable")
  --         end
  --       end,
  --       "Toggle Codeium",
  --     },
  --   }, { prefix = "<leader>" })
  -- end,
}
