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
    -- NOTE:more than just an adapter
    'nvim-flutter/flutter-tools.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = true,
  },
  keys = require 'plugins.plugin_modules.debug_keymaps',
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- NOTE:Where the debuggers are added, these are manually installed external executables
      ensure_installed = {
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
      command = 'netcoredbg', -- NOTE:Ensure that the path to the netcoredbg executable is in the path variable
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

    --NOTE:Flutter settings
    dap.adapters.dart = {
      type = 'executable',
      command = 'flutter',
      args = { 'debug_adapter' },
    }

    dap.configurations.dart = {
      {
        type = 'dart',
        request = 'launch',
        name = 'Launch Flutter Application',
        program = function()
          return vim.fn.input('Path to main Dart file: ', vim.fn.getcwd() .. '\\lib\\main.dart', 'file')
          -- return vim.fn.getcwd() .. '\\lib'
        end,
        cwd = '${workspaceFolder}',
        toolArgs = { '-d', 'chrome' }, -- Specify the target device; adjust as needed
        args = { '--flavor', 'development' }, -- Additional arguments for the Flutter run command
        -- dartSdkPath = '/path/to/dart-sdk', -- Optional: specify the Dart SDK path
        -- flutterSdkPath = 'C:\\SDKs\\flutter\\bin', -- Optional: specify the Flutter SDK path
        env = { VAR_NAME = 'value' }, -- Environment variables for the debugging session
        console = 'integratedTerminal', -- Use Neovim's integrated terminal for input/output
      },
    }

    -- NOTE: Install language specific configs
    require('dap-python').setup 'python3'

    require('flutter-tools').setup {
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      lsp = {
        on_attach = function(client, bufnr)
          -- Your custom on_attach function
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      },
    }
  end,
}
