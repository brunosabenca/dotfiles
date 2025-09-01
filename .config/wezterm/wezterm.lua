local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "zsh", "-l" }

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Gnome"

-- Command to find options: wezterm ls-fonts --list-system
config.font = wezterm.font("Monaspace Krypton Frozen", { weight = "Medium", stretch = "Normal", style = "Normal" })

config.font_size = 12
config.line_height = 1.2
config.color_scheme = "Catppuccin Mocha"

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Fixes weird issue with font sometimes having weird kerning
config.cell_width = 1

config.adjust_window_size_when_changing_font_size = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.use_fancy_tab_bar = false

return config
