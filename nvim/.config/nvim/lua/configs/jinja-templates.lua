-- Finds a Jinja project's template folder so jinja-lsp can resolve {% extends/include "…" %}.
-- Used by jinja_lsp's before_init in configs/lsp-servers.lua. Order:
--   1. Jinja2Templates(directory=…) (FastAPI/Starlette) or template_folder=… (Flask) in Python code
--   2. the first folder named `templates`
--   3. the project root

local M = {}

local SKIP = { [".git"] = true, [".venv"] = true, venv = true, node_modules = true, __pycache__ = true }
local MAX_DEPTH = 5

-- last string literal inside the argument, so `BASE_DIR / "templates"` yields "templates"
local PATTERNS = {
  "Jinja2Templates%s*%(%s*directory%s*=%s*([^,%)]+)",
  "Jinja2Templates%s*%(%s*([^,%)=]+)[,%)]", -- positional: Jinja2Templates("templates")
  "template_folder%s*=%s*([^,%)]+)",
}

local function last_string(expr)
  local found
  for s in expr:gmatch "[\"']([^\"']+)[\"']" do
    found = s
  end
  return found
end

--- Files under `root` (skipping venvs, node_modules, …) matching `pred(name, type)`.
local function walk(root, pred)
  local out = {}
  for name, type in
    vim.fs.dir(root, {
      depth = MAX_DEPTH,
      skip = function(dir)
        return not SKIP[vim.fs.basename(dir)]
      end,
    })
  do
    if pred(name, type) then
      out[#out + 1] = vim.fs.joinpath(root, name)
    end
  end
  return out
end

local function is_dir(path)
  return vim.fn.isdirectory(path) == 1
end

--- Template folder declared in Python code, as an absolute path (or nil).
function M.from_python(root)
  local pyfiles = walk(root, function(name, type)
    return type == "file" and name:match "%.py$"
  end)
  for _, file in ipairs(pyfiles) do
    local ok, lines = pcall(vim.fn.readfile, file)
    if ok then
      local text = table.concat(lines, "\n")
      for _, pat in ipairs(PATTERNS) do
        local expr = text:match(pat)
        local dir = expr and last_string(expr)
        if dir then
          -- relative to where the app runs (root) or to the file (BASE_DIR / "templates")
          for _, base in ipairs { root, vim.fs.dirname(file) } do
            local path = vim.fs.normalize(vim.fs.joinpath(base, dir))
            if is_dir(path) then
              return path
            end
          end
        end
      end
    end
  end
end

--- True when the project configures jinja-lsp itself (`[tool.jinja-lsp]`), which jinja-lsp
--- reads on its own; our startup settings would override it.
function M.has_project_config(root)
  for _, name in ipairs { "pyproject.toml", "jinja-lsp.toml" } do
    local ok, lines = pcall(vim.fn.readfile, vim.fs.joinpath(root, name))
    if ok and table.concat(lines, "\n"):match "%[tool%.jinja%-lsp%]" then
      return true
    end
  end
  return false
end

--- Template folder for `root`, relative to it ("./app/views", "./" …) as jinja-lsp expects.
function M.find(root)
  local dir = M.from_python(root)
  if not dir then
    local named = walk(root, function(name, type)
      return type == "directory" and vim.fs.basename(name) == "templates"
    end)
    table.sort(named, function(a, b) -- shallowest first
      return #a < #b
    end)
    dir = named[1]
  end
  if not dir then
    return "./"
  end
  return "./" .. (vim.fs.relpath(root, dir) or ".")
end

return M
