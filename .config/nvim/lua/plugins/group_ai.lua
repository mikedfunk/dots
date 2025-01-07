return {
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
}
