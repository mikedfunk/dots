return {
  'cormacrelf/dark-notify',
  config = function()
    require 'dark_notify'.run {
      onchange = function()
        vim.cmd 'silent! !tmux source ~/.config/tmux/tmux.conf &'
      end,
    }
  end
}
