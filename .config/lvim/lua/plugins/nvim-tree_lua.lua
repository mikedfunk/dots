-- TODO: rewrite without lvim global object

return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- https://github.com/nvim-tree/nvim-tree.lua/issues/674
    lvim.builtin.nvimtree.hide_dotfiles = nil
    lvim.builtin.nvimtree.ignore = nil
    lvim.builtin.nvimtree.git = {
      enable = true,
      ignore = true,
    }

    lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.unstaged = lvim.icons.git.FileUnstaged
    lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.untracked = lvim.icons.git.FileUntracked
    lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.staged = lvim.icons.git.FileStaged

    lvim.builtin.nvimtree.setup.disable_netrw = true
    lvim.builtin.nvimtree.setup.hijack_netrw = true

    -- match lsp icons
    lvim.builtin.nvimtree.setup.diagnostics.icons = {
      error = lvim.icons.diagnostics.Error,
      hint = lvim.icons.diagnostics.Hint,
      info = lvim.icons.diagnostics.Information,
      warning = lvim.icons.diagnostics.Warning,
    }

    if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '\\.git') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '\\.git') end
    if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '\\.null-ls*') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '\\.null-ls*') end
    require("lvim.core.nvimtree").setup()
    vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFindFileToggle<CR>', { noremap = true, desc = 'Explore File' })
  end,
}
