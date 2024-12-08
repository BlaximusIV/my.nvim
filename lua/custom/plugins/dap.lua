return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          -- CHANGE THIS to your path!
          command = 'C:\\Users\\Neal\\nvim_resources\\codelldb-win32-x64.vsix', -- Update this line with the absolute path to the codelldb vsix file
          args = { '--port', '${port}' },

          -- On windows you may have to uncomment this:
          detached = false,
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      local function compile_and_debug()
        local file_dir = vim.fn.expand '%:p:h'
        local file_name = vim.fn.expand '%:t:r'
        local executable = file_dir .. '/' .. file_name

        -- Change depending on the current language
        local compile_cmd = string.format('g++ -g "%s" -o "%s"', vim.fn.expand '%:p', executable)
        local compile_result = os.execute(compile_cmd)

        if compile_result == 0 then
          -- Compilation succeeded
          dap.configurations.cpp[1].program = executable
          dap.continue()
        else
          print 'Compilation failed'
        end
      end

      _G.compile_and_debug = compile_and_debug

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F5>', ':lua _G.compile_and_debug()<CR>', { noremap = true })
      vim.keymap.set('n', '<F11>', dap.step_into)
      vim.keymap.set('n', '<F10>', dap.step_over)
      vim.keymap.set('n', '<F9>', dap.step_out)
      vim.keymap.set('n', '<F8>', dap.step_back)
      vim.keymap.set('n', '<F4>', dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
