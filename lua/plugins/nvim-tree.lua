return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function my_on_attach(bufnr)
      local api = require 'nvim-tree.api'

      api.config.mappings.default_on_attach(bufnr)
    end
    require('nvim-tree').setup {
      on_attach = my_on_attach,
    }
    -- custom mappings
    vim.keymap.set('n', '<leader>e', require('nvim-tree.api').tree.toggle, { desc = 'Toggle the file [E]xplorer' })
  end,
}
