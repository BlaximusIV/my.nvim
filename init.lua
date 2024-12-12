require("testplugin")

-- General Vim Editing Configuration
-- Documentation for individual options can be found at https://vimdoc.sourceforge.net/htmldoc/options.html
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
-- Also try
-- vim.opt.signcolumn = number

-- How many milliseconds to wait with nothing typed before saving swap to disk
vim.opt.updatetime = 250

-- The time in milliseconds that is waited for a key code or mapped key sequence to complete.
vim.opt.timeoutlen = 300

-- How splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set how neovim displays some whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show shich line your cursor is on
vim.opt.cursorline = true

-- Minimum number of screen lines to keep above and below the cursor, as a buffer
vim.opt.scrolloff = 10

-- Keymaps
