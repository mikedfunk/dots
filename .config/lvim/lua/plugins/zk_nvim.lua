-- local setup_zk_conceal = function()
--   vim.cmd [[
--   " markdownWikiLink is a new region
--   syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends
--   " markdownLinkText is copied from runtime files with 'concealends' appended
--   syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends
--   " markdownLink is copied from runtime files with 'conceal' appended
--   syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal
--   ]]

--   vim.wo.conceallevel = 2
-- end

return {
  'mickael-menu/zk-nvim',
  ft = 'markdown',
  branch = 'main',
  init = function()
    -- lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { 'markdown' }

    lvim.builtin.which_key.mappings['z'] = {
      name = 'Zettelkasten',
      n = { '<Cmd>ZkNew { title = vim.fn.input("Title: ") }<CR>', 'New' },
      o = { '<Cmd>ZkNotes { sort = { "modified" } }<CR>', 'Open' },
      t = { '<Cmd>ZkTags<CR>', 'Tags' },
      s = { '<Cmd>ZkNotes { sort = { "modified" }, match = vim.fn.input("Search: ") }<CR>', 'Search' },
    }

    lvim.builtin.which_key.vmappings['z'] = {
      name = 'Zettelkasten',
      s = { ":'<,'>ZkMatch<CR>", 'Search' },
      -- t = { ":'<,'>ZkNewFromTitleSelection { dir = 'general' }<CR>", 'New from Title' },
      t = { ":'<,'>ZkNewFromTitleSelection<CR>", 'New from Title' },
      -- c = { ":'<,'>ZkNewFromContentSelection { dir = 'general' }<CR>", 'New from Content' },
      c = { ":'<,'>ZkNewFromContentSelection<CR>", 'New from Content' },
    }

    -- vim.api.nvim_create_augroup('zk_conceal', { clear = true })
    -- vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', group = 'zk_conceal', callback = setup_zk_conceal })
  end,
  config = function()
    -- starts language server
    require 'zk'.setup()
  end
}
