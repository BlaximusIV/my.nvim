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
    {
      'nvim-flutter/flutter-tools.nvim',
      lazy = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim',
      },
      config = true,
    },
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
        'flutter-tools',
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

    --NOTE:Flutter settings, should be good enough for lsp at this point

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- alternatively you can override the default configs
    require('flutter-tools').setup {
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = true,
        },
      },
      -- debugger = { -- integrate with nvim dap + install dart code debugger
      --   enabled = false,
      --   exception_breakpoints = {},
      --   evaluate_to_string_in_debug_views = true,
      --   register_configurations = function(paths)
      --     require('dap').configurations.dart = {
      --       --put here config that you would find in .vscode/launch.json
      --     }
      --     -- If you want to load .vscode launch.json automatically run the following:
      --     -- require("dap.ext.vscode").load_launchjs()
      --   end,
      -- },
      fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
      widget_guides = {
        enabled = false,
      },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = true, -- highlight the background
          background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = true, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = '■', -- the virtual text character to highlight
        },
        outline = {
          open_cmd = '30vnew',
          auto_open = true,
        },
        capabilities = capabilities,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = 'prompt', -- "always"
          enableSnippets = true,
          updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
        },
      },
    }

    dap.adapters.dart = {
      type = 'executable',
      command = 'flutter',
      args = { 'debug_adapter' },
    }

    -- NOTE: Install language specific configs
    require('dap-python').setup 'python3'
  end,
}
