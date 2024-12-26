return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    icons = {
      mappings = true,
      -- Because a Nerd Font is being used, set to an empty table,
      -- which will use the default which-key Nerd Font icons
      keys = {},
    },
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>e', group = '[E]xplorer', mode = { 'n' } },
    },
  },
}
