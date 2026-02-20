-- Load environment variables from .env file
local M = {}

function M.load()
  local env_file = vim.fn.stdpath("config") .. "/.env"
  local file = io.open(env_file, "r")

  if file then
    for line in file:lines() do
      -- Skip empty lines and comments
      if line ~= "" and not line:match("^#") then
        local key, value = line:match("^([%w_]+)=(.+)$")
        if key and value then
          -- Remove quotes if present
          value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
          vim.env[key] = value
        end
      end
    end
    file:close()
  end
end

return M
