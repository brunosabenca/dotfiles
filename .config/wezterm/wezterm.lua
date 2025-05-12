local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	{ family = "PragmataPro", weight = "Regular" },
	"Symbols Nerd Font",
})

config.font_size = 14
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

return config
