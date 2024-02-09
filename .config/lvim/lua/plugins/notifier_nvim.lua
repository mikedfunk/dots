return {
  'vigoux/notifier.nvim',
  event = 'BufRead',
  opts = {
    ignore_messages = {
      'codespell',
      'null-ls', -- ignores diagnostics_on_open, not sure why
    }, -- ignore messages _from LSP servers_ with this name
    notify = {
      clear_timer = 5000, -- default 5000
      min_level = vim.log.levels.WARN, -- default INFO (hide No information available)
    },
    -- component_name_recall = true, -- Whether to prefix the title of the notification by the component name (e.g. lsp:null-ls)
  },
}
