require("nvchad.configs.lspconfig").defaults()

-- Suppress "No signature help available" — only show when LSP returns signatures
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  if result and result.signatures and #result.signatures > 0 then
    vim.lsp.handlers.signature_help(err, result, ctx, config)
  end
end

-- Auto-show signature help while typing function arguments
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method("textDocument/signatureHelp") then
      vim.api.nvim_create_autocmd({ "TextChangedI", "CursorHoldI" }, {
        buffer = args.buf,
        callback = function()
          local triggered_chars = {}
          if client.server_capabilities.signatureHelpProvider then
            triggered_chars = client.server_capabilities.signatureHelpProvider.triggerCharacters or {}
          end

          local cur_line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local char = cur_line:sub(col, col)

          if vim.tbl_contains(triggered_chars, char) then
            vim.lsp.buf.signature_help()
          end
        end,
      })
    end
  end,
})

local mason_cfg = require("configs.mason-config").lspconfig
local servers = mason_cfg.ensure_installed

vim.lsp.enable(servers)

require "configs.lsp-servers"