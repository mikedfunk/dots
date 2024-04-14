return {
  "mickael-menu/zk-nvim",
  dependencies = { "folke/which-key.nvim" },
  ft = "markdown",
  branch = "main",
  init = function()
    require("which-key").register({
      z = {
        name = "Zettelkasten",
        n = { '<Cmd>ZkNew { title = vim.fn.input("Title: ") }<CR>', "New" },
        o = { '<Cmd>ZkNotes { sort = { "modified" } }<CR>', "Open" },
        t = { "<Cmd>ZkTags<CR>", "Tags" },
        s = { '<Cmd>ZkNotes { sort = { "modified" }, match = vim.fn.input("Search: ") }<CR>', "Search" },
      },
    }, { prefix = "<leader>" })

    require("which-key").register({
      z = {
        name = "Zettelkasten",
        s = { ":'<,'>ZkMatch<CR>", "Search" },
        -- t = { ":'<,'>ZkNewFromTitleSelection { dir = 'general' }<CR>", 'New from Title' },
        t = { ":'<,'>ZkNewFromTitleSelection<CR>", "New from Title" },
        -- c = { ":'<,'>ZkNewFromContentSelection { dir = 'general' }<CR>", 'New from Content' },
        c = { ":'<,'>ZkNewFromContentSelection<CR>", "New from Content" },
      },
    }, { prefix = "<leader>", mode = "v" })

    -- vim.api.nvim_create_augroup('zk_conceal', { clear = true })
    -- vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', group = 'zk_conceal', callback = setup_zk_conceal })
  end,
  config = function()
    -- starts language server
    require("zk").setup()
  end,
}
