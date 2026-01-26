local dap = require "dap"

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
