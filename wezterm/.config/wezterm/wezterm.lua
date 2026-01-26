-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Build configuration
local config = wezterm.config_builder()

-- 🌙 My CoolNight Colorscheme (with #24EAF7 as Blue)
-- config.colors = {
-- 	foreground = "#CBE0F0",
-- 	background = "#011423",
--
-- 	-- Cursor
-- 	cursor_bg = "#47FF9C",
-- 	cursor_border = "#47FF9C",
-- 	cursor_fg = "#011423",
--
-- 	-- Selection
-- 	selection_bg = "#033259",
-- 	selection_fg = "#CBE0F0",
--
-- 	-- ANSI colors
-- 	ansi = {
-- 		"#214969", -- 0: Black
-- 		"#E52E2E", -- 1: Red
-- 		"#44FFB1", -- 2: Green
-- 		"#FFE073", -- 3: Yellow
-- 		"#24EAF7", -- 4: Blue 🔵 (your requested color)
-- 		"#A277FF", -- 5: Magenta
-- 		"#24EAF7", -- 6: Cyan (kept same for harmony)
-- 		"#CBE0F0", -- 7: White / Light FG
-- 	},
--
-- 	-- Bright ANSI colors
-- 	brights = {
-- 		"#214969", -- 8: Bright Black
-- 		"#E52E2E", -- 9: Bright Red
-- 		"#44FFB1", -- 10: Bright Green
-- 		"#FFE073", -- 11: Bright Yellow
-- 		"#24EAF7", -- 12: Bright Blue 🔵 (matches normal blue)
-- 		"#A277FF", -- 13: Bright Magenta
-- 		"#24EAF7", -- 14: Bright Cyan
-- 		"#FFFFFF", -- 15: Bright White
-- 	},
-- }

config.color_scheme = "Catppuccin Mocha"

-- 🖋 Font and Appearance
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19
config.line_height = 1.0
config.cell_width = 1.0

-- 🪟 Window styling
config.enable_tab_bar = false
-- config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 15

-- Return configuration
return config
