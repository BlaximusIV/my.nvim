return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add additional debuggers/adapters here
    -- NOTE:Debug adapters
    -- e.g. the dap extension for go: 'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
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
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      -- NOTE:Where the debuggers are added, these are manually installed external executables
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- The debugger itself, e.g. 'delve',
        'debugpy', -- Requires debugpy be installed, `pip install debugpy`
        'netcoredbg', -- www.github.com/Samsung/netcoredbg
      },
    }

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.set_log_level 'DEBUG'

    -- NOTE:C# settings
    dap.adapters.coreclr = {
      type = 'executable',
      command = 'C:\\Users\\Neal\\code_resources\\netcoredbg\\netcoredbg', -- NOTE: change to match current executable location and have rights to execute
      args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '\\bin\\Debug\\net9.0\\') -- NOTE:Update the path for operating system and project location
        end,
      },
    }

    -- NOTE: Install language specific configs
    --require('dap-go').setup {
    --delve = {
    ---- On Windows delve must be run attached or it crashes.
    ---- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --detached = vim.fn.has 'win32' == 0,
    --},
    --}
    require('dap-python').setup 'python3'
  end,
}
