-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

--config.colors = {
--	foreground = "#CBE0F0",
--	background = "#011423",
--	cursor_bg = "#47FF9C",
--	cursor_border = "#47FF9C",
--	cursor_fg = "#011423",
--	selection_bg = "#033259",
--	selection_fg = "#CBE0F0",
--	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
--	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
--}
config.colors = {
	foreground = "#D1D5DB",
	background = "#0F1115",

	cursor_bg = "#AEB4BA",
	cursor_border = "#AEB4BA",
	cursor_fg = "#0F1115",

	selection_bg = "#2A2F36",
	selection_fg = "#D1D5DB",

	ansi = {
		"#2B3036", -- black
		"#C05C5C", -- red
		"#8FB573", -- green
		"#C9A86A", -- yellow
		"#7FA6C4", -- blue
		"#A68ACB", -- magenta
		"#78BFC4", -- cyan
		"#D1D5DB", -- white
	},

	brights = {
		"#3A4047", -- bright black
		"#D07070",
		"#A3C98A",
		"#DDBE84",
		"#94B8D6",
		"#B59EDC",
		"#8ED3D6",
		"#E3E7EB",
	},
}

config.font = wezterm.font("PlemolJP Console NF")
config.font_size = 17

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.audible_bell = "Disabled"

-- Function to switch input source to alphanumeric
local function switch_to_abc()
	wezterm.background_child_process({ "/opt/homebrew/bin/im-select", "jp.monokakido.inputmethod.Kawasemi4.Roman" })
end

-- Switch input source to alphanumeric on startup
wezterm.on("gui-startup", function()
	switch_to_abc()
end)

-- Track previous focus state
local last_focused = false

-- Switch input source to alphanumeric when window gains focus
wezterm.on("update-status", function(window, pane)
	local is_focused = window:is_focused()
	if is_focused and not last_focused then
		switch_to_abc()
	end
	last_focused = is_focused
end)

-- and finally, return the configuration to wezterm
return config
