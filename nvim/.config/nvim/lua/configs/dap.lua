local dap = require "dap"

-- Visual breakpoint signs (replaces default 'B' text with proper icons)
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "DiagnosticOk" })
vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DiagnosticError", linehl = "", numhl = "" })

-- Go (delve adapter auto-configured by mason-nvim-dap)
dap.configurations.go = {
  { type = "delve", name = "Debug file", request = "launch", program = "${file}" },
  { type = "delve", name = "Debug package", request = "launch", program = "${workspaceFolder}" },
  { type = "delve", name = "Debug test", request = "launch", mode = "test", program = "${file}" },
}

-- Python (debugpy adapter auto-configured by mason-nvim-dap)
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return os.getenv "VIRTUAL_ENV" and (os.getenv "VIRTUAL_ENV" .. "/bin/python")
        or os.getenv "CONDA_PREFIX" and (os.getenv "CONDA_PREFIX" .. "/bin/python")
        or vim.fn.exepath "python3"
        or "python"
    end,
  },
}

-- JavaScript / TypeScript (js-debug-adapter auto-configured by mason-nvim-dap)
local js_config = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}
for _, lang in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
  dap.configurations[lang] = js_config
end

-- C/C++ configuration (codelldb adapter is auto-configured by mason-nvim-dap)
dap.configurations.c = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.cpp = dap.configurations.c

-- Rust configuration
dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      local cwd = vim.fn.getcwd()
      local cargo_toml = cwd .. "/Cargo.toml"
      if vim.fn.filereadable(cargo_toml) == 1 then
        local project_name = vim.fn.fnamemodify(cwd, ":t")
        local debug_path = cwd .. "/target/debug/" .. project_name
        if vim.fn.filereadable(debug_path) == 1 then
          return debug_path
        end
      end
      return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
