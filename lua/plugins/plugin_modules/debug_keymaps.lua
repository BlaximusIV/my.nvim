local keymaps = {
  {
    '<F5>',
    function()
      require('dap').continue()
    end,
    desc = 'Debug: Start/Continue',
  },
  {
    '<F11>',
    function()
      require('dap').step_into()
    end,
    desc = 'Debug: Step Into',
  },
  {
    '<F10>',
    function()
      require('dap').step_over()
    end,
    desc = 'Debug: Step Over',
  },
  {
    '<F12>',
    function()
      require('dap').step_out()
    end,
    desc = 'Debug: Step Out',
  },
  {
    '<leader>b',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'Debug: Toggle Breakpoint',
  },
  {
    '<leader>B',
    function()
      require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end,
    desc = 'Debug: Set Breakpoint',
  },
  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  {
    '<F7>',
    function()
      require('dapui').toggle()
    end,
    desc = 'Debug: See last session result.',
  },
}

return keymaps
