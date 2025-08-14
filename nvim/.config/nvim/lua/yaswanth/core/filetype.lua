-- Language-specific indentation settings
local M = {}

-- Function to set language-specific options
local function set_lang_options(lang, opts)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = lang,
        callback = function()
            for key, value in pairs(opts) do
                vim.opt_local[key] = value
            end
        end,
    })
end

-- Language configurations
local language_configs = {
    -- Web development (2 spaces)
    { languages = {"html", "css", "scss", "sass", "javascript", "typescript", "jsx", "tsx", "json", "yaml", "yml", "xml"}, 
      config = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true } },
    
    -- Python (4 spaces - PEP 8)
    { languages = {"python"}, 
      config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },
    
    -- Go (tabs)
    { languages = {"go"}, 
      config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = false } },
    
    -- Lua (4 spaces)
    { languages = {"lua"}, 
      config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },
    
    -- C/C++ (4 spaces)
    { languages = {"c", "cpp", "h", "hpp"}, 
      config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },
    
    -- Java (4 spaces)
    { languages = {"java"}, 
      config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },
    
    -- Rust (4 spaces)
    { languages = {"rust"}, 
      config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },
    
    -- Shell scripts (2 spaces)
    { languages = {"sh", "bash", "zsh"}, 
      config = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true } },
    
    -- Markdown (2 spaces)
    { languages = {"markdown", "md"}, 
      config = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true } },
    
    -- Config files (2 spaces)
    { languages = {"vim", "toml", "ini"}, 
      config = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true } },
}

-- Apply configurations
for _, lang_config in ipairs(language_configs) do
    for _, lang in ipairs(lang_config.languages) do
        set_lang_options(lang, lang_config.config)
    end
end

-- Auto-indentation on save (for files without dedicated formatters)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local filetype = vim.bo.filetype
        -- Only auto-indent for file types that don't have dedicated formatters
        local skip_filetypes = {
            "javascript", "typescript", "javascriptreact", "typescriptreact",
            "html", "css", "scss", "json", "yaml", "yml", "markdown",
            "python", "lua", "go", "rust", "c", "cpp", "java"
        }
        
        -- Skip if file type has a dedicated formatter
        if vim.tbl_contains(skip_filetypes, filetype) then
            return
        end
        
        -- Save cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        
        -- Fix indentation for the entire file
        vim.cmd("normal! gg=G")
        
        -- Restore cursor position
        pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
    end,
})

-- Add manual indentation command
vim.api.nvim_create_user_command("FixIndent", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal! gg=G")
    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
end, { desc = "Fix indentation for entire file" })

return M
