require("yaswanth.core")
require("yaswanth.lazy")

-- Fix for deprecated vim.lsp.get_active_clients() in Neovim 0.10+
if vim.lsp.get_active_clients then
    vim.lsp.get_active_clients = function(filter)
        return vim.lsp.get_clients(filter)
    end
end
