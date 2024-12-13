return {
  'echasnovski/mini.nvim',
  config = function()
    -- Add/delete/replace surrounding brackets, quotes etc.
    require('mini.surround').setup()
    -- Simple statusline
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = true }
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
