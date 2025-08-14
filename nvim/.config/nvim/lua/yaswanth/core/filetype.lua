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
    -- Web development (4 spaces)
    {
        languages = {
            "html",
            "css",
            "scss",
            "sass",
            "javascript",
            "typescript",
            "jsx",
            "tsx",
            "json",
            "yaml",
            "yml",
            "xml",
        },
        config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    },

    -- Python (4 spaces - PEP 8)
    { languages = { "python" }, config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },

    -- Go (4 spaces - overriding Go convention for consistency)
    { languages = { "go" }, config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },

    -- Lua (4 spaces)
    { languages = { "lua" }, config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },

    -- C/C++ (4 spaces)
    {
        languages = { "c", "cpp", "h", "hpp" },
        config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    },

    -- Java (4 spaces)
    { languages = { "java" }, config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },

    -- Rust (4 spaces)
    { languages = { "rust" }, config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true } },

    -- Shell scripts (4 spaces)
    {
        languages = { "sh", "bash", "zsh" },
        config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    },

    -- Markdown (4 spaces)
    {
        languages = { "markdown", "md" },
        config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    },

    -- Config files (4 spaces)
    {
        languages = { "vim", "toml", "ini" },
        config = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    },
}

-- Apply configurations
for _, lang_config in ipairs(language_configs) do
    for _, lang in ipairs(lang_config.languages) do
        set_lang_options(lang, lang_config.config)
    end
end

-- Global fallback to ensure 4-space indentation for any filetype not explicitly configured
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        -- Only apply if not already configured by language-specific settings
        local current_tabstop = vim.opt_local.tabstop:get()
        if current_tabstop == 8 then -- Default vim tabstop, means not configured
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.expandtab = true
        end
    end,
})

-- Auto-indentation on save (for files without dedicated formatters)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local filetype = vim.bo.filetype
        -- Only auto-indent for file types that don't have dedicated formatters
        local skip_filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "html",
            "css",
            "scss",
            "json",
            "yaml",
            "yml",
            "markdown",
            "python",
            "lua",
            "go",
            "rust",
            "c",
            "cpp",
            -- "java", -- Removed so Java uses auto-indentation with 4 spaces
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

-- Add manual indentation commands
vim.api.nvim_create_user_command("FixIndent", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- Convert tabs to spaces first
    vim.cmd("%s/\t/    /g")
    -- Then fix indentation
    vim.cmd("normal! gg=G")
    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
end, { desc = "Fix indentation for entire file and convert tabs to 4 spaces" })

-- Command to convert tabs to 4 spaces
vim.api.nvim_create_user_command("TabsToSpaces", function()
    vim.cmd("%s/\t/    /g")
end, { desc = "Convert all tabs to 4 spaces" })

-- Auto-convert tabs to spaces when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        -- Only convert if file contains tabs and expandtab is set
        if vim.bo.expandtab then
            local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local has_tabs = false
            for _, line in ipairs(content) do
                if line:find("\t") then
                    has_tabs = true
                    break
                end
            end
            if has_tabs then
                vim.cmd("silent! %s/\t/    /g")
            end
        end
    end,
})

return M
