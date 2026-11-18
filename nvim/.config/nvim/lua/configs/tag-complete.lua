-- VS Code-style tag completion: accepting a tag name from the completion menu right after `<`
-- (e.g. `<di` → Enter) types the `>` for you; nvim-ts-autotag then adds `</div>` and leaves the
-- cursor between the tags: `<div>|</div>`. Hooked to nvim-cmp's confirm_done (see plugins/autotag.lua).

local M = {}

M.filetypes = {
  html = true,
  htmlangular = true,
  htmldjango = true,
  jinja = true,
  javascriptreact = true,
  typescriptreact = true,
  vue = true,
  svelte = true,
  astro = true,
  xml = true,
}

--- Returns true when the text before the cursor is a just-completed opening tag name.
---@param before string line text up to the cursor
---@param after string line text after the cursor
function M.is_tag_name(before, after)
  local prev, name = before:match "(.?)<([%w_][%w%.%-:_]*)$"
  if not name then
    return false
  end
  -- `useState<string`, `Array<T`, `foo()<x`: a generic or comparison, not a tag
  if prev:match "[%w_%]%)]" then
    return false
  end
  -- tag already continues (`<div>`, `<div/`), nothing to do
  return not after:match "^[>/]"
end

function M.on_confirm_done()
  if not M.filetypes[vim.bo.filetype] then
    return
  end
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  if M.is_tag_name(line:sub(1, col), line:sub(col + 1)) then
    -- "m": let nvim-ts-autotag's insert-mode `>` mapping run and add the closing tag
    vim.api.nvim_feedkeys(">", "m", false)
  end
end

return M
