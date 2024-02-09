-- Q: Why use ale and not null-ls?
--
-- A: I sometimes get zombie processes started upstream by null-ls. It seems
-- to kill parent tasks when they time out or something, but if those parent
-- tasks had spawned child tasks, those never get killed but still end up
-- taking memory indefinitely. This adds up to enough memory that it slows
-- down my machine significantly. I've had this problem with phpcs, phpstan,
-- even codespell. An annoying workaround is to occasionally
-- `kill -9 {parent_task_id}` on the parent task of the zombie prcesses,
-- but that's a pain in the ass.
--
-- If these problems get fixed I will definitely switch!! But until that
-- happens, ALE is more stable and less problematic for linting with phpcs
-- and phpstan. I've reproduced these problems on a vanilla lunarvim config.

return {
  'dense-analysis/ale',
  init = function()
    lvim.keys.normal_mode['l'] = lvim.keys.normal_mode['l'] or {}
    lvim.keys.normal_mode['l']['F'] = { '<Cmd>ALEFix<CR>', 'Fix with ALE' }
  end,
  -- event = 'BufRead',
  config = function()
    vim.g.ale_use_neovim_diagnostics_api = true -- save so much bullshit https://github.com/dense-analysis/ale/pull/4135
    vim.g.ale_lint_delay = 50
    vim.g.ale_lint_on_filetype_changed = false
    vim.g.ale_floating_preview = false -- neovim floating window to preview errors. This combines ale_detail_to_floating_preview and ale_hover_to_floating_preview.
    vim.g.ale_sign_highlight_linenrs = false
    vim.g.ale_disable_lsp = true
    vim.g.ale_echo_cursor = false
    vim.g.ale_set_highlights = false
    vim.g.ale_set_loclist = false
    vim.g.ale_set_signs = false
    vim.g.ale_linters_explicit = true -- only use configured linters instead of everything

    vim.g.ale_linters = {
      php = {
        'phpcs',
        'phpstan',
      },
    }

    vim.g.ale_fixers = {
      php = {
        'phpcbf',
        -- 'php_cs_fixer', -- this is enabled conditionally in the php ftplugin
      },
    }

    vim.g.ale_php_phpcbf_executable = vim.env.HOME .. '/.support/phpcbf-helper.sh'
    vim.g.ale_php_phpcbf_use_global = true
    vim.g.ale_php_phpcs_options = '--warning-severity=3'
    vim.g.ale_php_phpstan_level = 9
    vim.g.ale_php_phpstan_memory_limit = '200M'
  end,
}
