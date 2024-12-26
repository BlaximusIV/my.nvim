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
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('flutter-tools').setup {}
      end,
      ft = 'dart',
    },
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

    -- NOTE: Install language specific configs
    require('dap-python').setup 'python3'

    require('flutter-tools').setup {
      ui = {
        border = 'rounded',
        -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
        -- please note that this option is eventually going to be deprecated and users will need to
        -- depend on plugins like `nvim-notify` instead.
        notification_style = 'native',
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = true,
        },
      },
      debugger = { -- integrate with nvim dap + install dart code debugger
        enabled = true,
        -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
        -- see |:help dap.set_exception_breakpoints()| for more info
        exception_breakpoints = {},
        evaluate_to_string_in_debug_views = true,
        register_configurations = function(paths)
          dap.configurations.dart = {
            --put here config that you would find in .vscode/launch.json
            name = 'Neo Flutter',
            request = 'launch',
            type = 'dart',
          }
        end,
      },
      flutter_path = 'C:\\SDKs\\flutter\\bin', -- <-- this takes priority over the lookup' NOTE:Change for local location
      flutter_lookup_cmd = nil, -- example "dirname $(which flutter)" or "asdf where flutter"
      root_patterns = { '.git', 'pubspec.yaml' }, -- patterns to find the root of your flutter project
      fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = 'ErrorMsg', -- highlight for the closing tag
        prefix = '>', -- character to use for close tag e.g. > Widget
        priority = 10, -- priority of virtual text in current line
        -- consider to configure this when there is a possibility of multiple virtual text items in one line
        -- see `priority` option in |:help nvim_buf_set_extmark| for more info
        enabled = true, -- set to false to disable
      },
      dev_log = {
        enabled = true,
        filter = nil, -- optional callback to filter the log
        -- takes a log_line as string argument; returns a boolean or nil;
        -- the log_line is only added to the output if the function returns true
        notify_errors = false, -- if there is an error whilst running then notify the user
        open_cmd = '15split', -- command to use to open the log buffer
        focus_on_open = true, -- focus on the newly opened log window
      },
      dev_tools = {
        autostart = false, -- autostart devtools server if not detected
        auto_open_browser = false, -- Automatically opens devtools in the browser
      },
      outline = {
        open_cmd = '30vnew', -- command to use to open the outline buffer
        auto_open = false, -- if true this will open the outline automatically when it is first populated
      },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = false, -- highlight the background
          background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = false, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = '■', -- the virtual text character to highlight
        },
        on_attach = nil,
        capabilities = function() -- vim.lsp.protocol.make_client_capabilities(), -- e.g. lsp_status capabilities
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
          return capabilities
        end,
        --- OR you can specify a function to deactivate or change or control how the config is created
        -- capabilities = function(config)
        --   config.specificThingIDontWant = false
        --   return config
        -- end,
        -- see the link below for details on each option:
        -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = { 'C:\\SDKs\\flutter\\bin' },
          renameFilesWithClasses = 'prompt', -- "always"
          enableSnippets = true,
          updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
        },
      },
    }

    dap.configurations.dart = {
      {
        type = 'dart',
        request = 'launch',
        name = 'Nvim Flutter',
        -- program = function()
        --   -- return vim.fn.input('Path to main Dart file: ', vim.fn.getcwd() .. '\\lib\\main.dart', 'file')
        --   -- return vim.fn.getcwd() .. '/lib/main.dart'
        --   return 'lib/main.dart'
        --   -- return (vim.fn.input('Path to main Dart file: ', '', 'file'))
        -- end,
        -- cwd = '${workspaceFolder}',
        -- toolArgs = { '-d', 'chrome' }, -- Specify the target device; adjust as needed
        -- args = { '--flavor', 'development' }, -- Additional arguments for the Flutter run command
        -- dartSdkPath = 'C:\\SDKs\\flutter\\bin\\cache\\dart-sdk\\bin\\dart', -- Optional: specify the Dart SDK path
        -- flutterSdkPath = 'C:\\SDKs\\flutter\\bin\\flutter.bat', -- Optional: specify the Flutter SDK path
        -- env = { VAR_NAME = 'value' }, -- Environment variables for the debugging session
        -- console = 'integratedTerminal', -- Use Neovim's integrated terminal for input/output
      },
    }

    -- -- NOTE: Install language specific configs
    -- require('dap-python').setup 'python3'
    --
    -- require('flutter-tools').setup {
    --   debugger = {
    --     enabled = true,
    --     run_via_dap = true,
    --   },
    --   lsp = {
    --     on_attach = function(client, bufnr)
    --       -- Your custom on_attach function
    --     end,
    --     capabilities = require('cmp_nvim_lsp').default_capabilities(),
    --   },
    -- }
  end,
}
