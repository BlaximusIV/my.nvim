
require("config.vimoptions")
require("config.vimkeymaps")

-- Highlight yanks
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- NOTE: Install the 'lazy.nvim' plugin manager
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: ADD PLUGINS VIA LAZY PLUGIN MANAGER
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- Theme
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Interact with git in the editor
  'lewis6991/gitsigns.nvim',

  -- Show pending keybindings
  require('plugins.which-key'),

  -- Lua LSP for neovim config
  -- WARN: Not sure that these are working
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  -- NOTE:Highlight comments with 'WORD: ' syntax. Supports: note, hack, warn, perf, and test
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- A grab bag of functionality
  require('plugins.mini')

  -- Fuzzy finding
  -- WARN: Not working quite yet
  -- require('plugins.telescope')

  -- LSP

  -- Code Navigation (tree-sitter)

  -- Debugging

}, {
  ui = {
    -- Set icons to an empty table which will use the default lazy.nvim defined Nerd Font Icons
    icons = {}
  }
})

