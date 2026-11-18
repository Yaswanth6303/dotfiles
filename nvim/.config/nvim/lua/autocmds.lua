require "nvchad.autocmds"

vim.filetype.add {
  filename = {
    ["BUILD"] = "bzl",
    ["BUILD.bazel"] = "bzl",
    ["WORKSPACE"] = "bzl",
    ["WORKSPACE.bazel"] = "bzl",
    -- docker_compose_language_service only attaches to this filetype
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    [".*%.bzl"] = "bzl",
    [".*%.bazel"] = "bzl",
  },
}

-- Toggle format-on-save. `:FormatToggle` toggles globally, `:FormatToggle!` toggles only this buffer.
vim.api.nvim_create_user_command("FormatToggle", function(args)
  if args.bang then
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify("Format on save (buffer): " .. (vim.b.disable_autoformat and "OFF" or "ON"))
  else
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format on save (global): " .. (vim.g.disable_autoformat and "OFF" or "ON"))
  end
end, { desc = "Toggle format on save (! for buffer-local)", bang = true })

-- Briefly highlight yanked text — production-grade quality-of-life
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank { timeout = 150 }
  end,
})

-- Defensive: if something tries to open a directory as a file (stale shada
-- oldfiles entry, accidental `:e ~`, etc.), defer briefly so nvim-tree's
-- directory-hijack runs first; if no plugin claimed the buffer, wipe it
-- silently instead of throwing ENOENT.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("skip_directory_buffers", { clear = true }),
  callback = function(args)
    if args.file == "" or vim.fn.isdirectory(args.file) == 0 then
      return
    end
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      local ft = vim.bo[args.buf].filetype
      if ft == "NvimTree" or ft == "oil" or ft == "netrw" then
        return -- a file-explorer plugin hijacked it; leave alone
      end
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end, 100)
  end,
})

-- `exit` in a split terminal (<leader>h / <leader>v): close its window instead of leaving an empty split.
-- Neovim swaps the exited terminal's buffer out before TermClose runs, so remember the window up front.
-- Only on a clean exit (status 0) so error output stays visible.
local term_group = vim.api.nvim_create_augroup("close_exited_terminal", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
  group = term_group,
  callback = function(args)
    if vim.bo[args.buf].buftype == "terminal" then
      vim.w.term_buf = args.buf
    end
  end,
})
vim.api.nvim_create_autocmd("TermClose", {
  group = term_group,
  callback = function(args)
    if vim.v.event.status ~= 0 then
      return
    end
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.w[win].term_buf == args.buf and #vim.api.nvim_tabpage_list_wins(0) > 1 then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end)
  end,
})
