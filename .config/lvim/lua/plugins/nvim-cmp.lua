lvim.builtin.cmp.cmdline.enable = true

-- table.insert(lvim.builtin.cmp.cmdline.options[2].sources, { name = 'nvim_lsp_document_symbol' })

-- lvim.builtin.cmp.experimental.ghost_text = true

lvim.builtin.cmp.formatting.source_names['buffer'] = ''
lvim.builtin.cmp.formatting.source_names['buffer-lines'] = '≡'
lvim.builtin.cmp.formatting.source_names['calc'] = ''
lvim.builtin.cmp.formatting.source_names['cmp_jira'] = ''
lvim.builtin.cmp.formatting.source_names['cmp_tabnine'] = '󰚩' --  ➒
lvim.builtin.cmp.formatting.source_names['color_names'] = ''
lvim.builtin.cmp.formatting.source_names["copilot"] = ""
lvim.builtin.cmp.formatting.source_names['dap'] = ''
lvim.builtin.cmp.formatting.source_names['dictionary'] = ''
lvim.builtin.cmp.formatting.source_names['doxygen'] = '' -- 󰙆
lvim.builtin.cmp.formatting.source_names['emoji'] = '' -- 
lvim.builtin.cmp.formatting.source_names['git'] = ''
lvim.builtin.cmp.formatting.source_names['jira_issues'] = ''
lvim.builtin.cmp.formatting.source_names['luasnip'] = '✄'
lvim.builtin.cmp.formatting.source_names['luasnip_choice'] = ''
lvim.builtin.cmp.formatting.source_names['marksman'] = '󰓾' -- 🞋
lvim.builtin.cmp.formatting.source_names['nerdfont'] = '󰬴'
lvim.builtin.cmp.formatting.source_names['nvim_lsp'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_document_symbol'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_signature_help'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lua'] = ''
lvim.builtin.cmp.formatting.source_names['path'] = '󰉋' --  
lvim.builtin.cmp.formatting.source_names['plugins'] = '' --  
lvim.builtin.cmp.formatting.source_names['rg'] = ''
lvim.builtin.cmp.formatting.source_names['tmux'] = ''
lvim.builtin.cmp.formatting.source_names['treesitter'] = ''
lvim.builtin.cmp.formatting.source_names['vsnip'] = '✄'
lvim.builtin.cmp.formatting.source_names['zk'] = ''

lvim.builtin.cmp.formatting.kind_icons.Method = lvim.icons.kind.Method -- default is 
lvim.builtin.cmp.formatting.kind_icons.Function = lvim.icons.kind.Function -- default is ƒ

local is_cmp_installed, cmp = pcall(require, 'cmp')
if is_cmp_installed then lvim.builtin.cmp.preselect = cmp.PreselectMode.None end
lvim.builtin.cmp.mapping['<C-J>'] = lvim.builtin.cmp.mapping['<Tab>']
lvim.builtin.cmp.mapping['<C-K>'] = lvim.builtin.cmp.mapping['<S-Tab>']

-- lvim.builtin.cmp.mapping['<C-Y>'] = function() require 'cmp'.mapping.confirm({ select = false }) end -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

return {}
