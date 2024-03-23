-- TODO: rewrite without lvim global object
return {
  'tzachar/cmp-tabnine',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  build = './install.sh',
  cond = function()
    -- do not enable tabnine for dotfiles. It takes tons of CPU.
    local pwd = vim.api.nvim_exec('pwd', true)
    return pwd:match('/Code')
  end,
  init = function()
    if not vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'cmp_tabnine' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'cmp_tabnine' })
  end,
  config = function()
    require 'cmp_tabnine.config':setup {
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      ignored_file_types = {
        php = true, -- it's cool but LSP results are smarter, and if it's behind LSP results it's too far to scroll to see them :/
        phtml = true,
        html = true,
      },
    }

    -- make tabnine higher priority
    --
    -- local compare = require 'cmp.config.compare'
    -- require 'cmp'.setup {
    --   sorting = {
    --     priority_weight = 2,
    --     comparators = {
    --       require 'cmp_tabnine.compare',
    --       compare.offset,
    --       compare.exact,
    --       compare.score,
    --       compare.recently_used,
    --       compare.kind,
    --       compare.sort_text,
    --       compare.length,
    --       compare.order,
    --     },
    --   },
    -- }

    vim.api.nvim_create_augroup('tabnine_prefetch', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = 'tabnine_prefetch',
      pattern = 'php',
      callback = function()
        require 'cmp_tabnine':prefetch(vim.fn.expand('%:p'))
      end
    })
  end,
}
