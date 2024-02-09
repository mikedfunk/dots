-- automatically create missing directories on save
return {
  'jghauser/mkdir.nvim',
  event = 'BufRead',
  config = function() require 'mkdir' end
}
