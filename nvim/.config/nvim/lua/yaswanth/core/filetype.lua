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

        -- Skip if file type has a dedicated formatter (conform.nvim handles these)
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

-- Add manual indentation commands with improved error handling
vim.api.nvim_create_user_command("FixIndent", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local filetype = vim.bo.filetype
    
    -- First, ensure the file has the correct indentation settings
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    
    -- Safely convert tabs to spaces first with error handling
    local ok, err = pcall(function()
        vim.cmd("silent! %s/\t/    /ge")
    end)
    
    if not ok then
        vim.notify("Tab conversion failed: " .. (err or "unknown error"), vim.log.levels.WARN)
    end
    
    -- Then safely fix indentation with error handling
    ok, err = pcall(function()
        vim.cmd("silent! normal! gg=G")
    end)
    
    if not ok then
        vim.notify("Indentation failed: " .. (err or "unknown error"), vim.log.levels.WARN)
    end
    
    -- Restore cursor position
    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
    
    vim.notify("Indentation fixed for " .. (filetype or "current file"), vim.log.levels.INFO)
end, { desc = "Fix indentation for entire file and convert tabs to 4 spaces" })

-- Enhanced FixIndent command with filetype-specific handling
vim.api.nvim_create_user_command("FixIndentSafe", function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local filetype = vim.bo.filetype
    local buf = vim.api.nvim_get_current_buf()
    
    -- Check if buffer is modifiable
    if not vim.api.nvim_buf_get_option(buf, "modifiable") then
        vim.notify("Buffer is not modifiable", vim.log.levels.WARN)
        return
    end
    
    -- Set appropriate indentation settings based on filetype
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    
    -- Language-specific indentation fixes
    if filetype == "c" or filetype == "cpp" or filetype == "h" or filetype == "hpp" then
        -- For C/C++, ensure cindent is enabled for better auto-indentation
        vim.bo.cindent = true
        vim.bo.cinoptions = ">4,n-2,{2,^-2,t0,+2,(0,u0,w1,m1"
    elseif filetype == "javascript" or filetype == "typescript" or filetype == "jsx" or filetype == "tsx" then
        -- For JavaScript/TypeScript, set appropriate settings
        vim.bo.smartindent = true
    elseif filetype == "python" then
        -- Python-specific settings
        vim.bo.smartindent = true
        vim.bo.autoindent = true
    end
    
    -- Convert tabs to spaces with error handling
    local tab_conversion_ok = pcall(function()
        local line_count = vim.api.nvim_buf_line_count(buf)
        for i = 0, line_count - 1 do
            local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
            if line and line:find("\t") then
                local new_line = line:gsub("\t", "    ")
                vim.api.nvim_buf_set_lines(buf, i, i + 1, false, { new_line })
            end
        end
    end)
    
    if not tab_conversion_ok then
        vim.notify("Tab conversion failed", vim.log.levels.WARN)
    end
    
    -- Apply indentation with language-specific handling
    local indent_ok = pcall(function()
        if filetype == "c" or filetype == "cpp" or filetype == "h" or filetype == "hpp" then
            -- Use cindent for C/C++
            vim.cmd("silent! normal! gg=G")
        elseif filetype == "javascript" or filetype == "typescript" then
            -- For JS/TS, use smartindent
            vim.cmd("silent! normal! ggVG=")
        elseif filetype == "python" then
            -- For Python, be more careful with indentation
            vim.cmd("silent! normal! gg=G")
        else
            -- Generic indentation for other file types
            vim.cmd("silent! normal! gg=G")
        end
    end)
    
    if not indent_ok then
        vim.notify("Indentation failed for " .. filetype, vim.log.levels.WARN)
    end
    
    -- Restore cursor position
    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
    
    vim.notify("Indentation fixed for " .. (filetype ~= "" and filetype or "unknown file type"), vim.log.levels.INFO)
end, { desc = "Fix indentation safely with filetype-specific handling" })

-- Command to convert tabs to 4 spaces
vim.api.nvim_create_user_command("TabsToSpaces", function()
    pcall(function()
        vim.cmd("silent! %s/\t/    /ge")
    end)
    vim.notify("Converted tabs to spaces", vim.log.levels.INFO)
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
