local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.color_scheme = "Catppuccin Mocha"
local custom_colors = {
	red = "#e64553",
	cyan = "#04a5e5",
	magenta = "#ea76cb",
	yellow = "#df8e1d",
}

config.scrollback_lines = 100000

-- Command to find options: wezterm ls-fonts --list-system
config.font = wezterm.font({
	family = "JetBrains Mono",
	weight = "Regular",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 14
config.line_height = 1.4
-- config.freetype_load_target = "Light"
-- config.freetype_load_flags = "NO_HINTING"

-- config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

config.font_size = 12
config.line_height = 1.2
config.color_scheme = "Catppuccin Mocha"

-- Fixes weird issue with font sometimes having weird kerning
config.cell_width = 1

config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = ":", mods = "LEADER", action = act.ActivateCommandPalette },

	-- Workspace (similar to session in Tmux)
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	-- Tab (similar to window in Tmux)
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = ".", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
	--{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	--{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

	-- Pane
	{
		key = '"',
		mods = "SHIFT|ALT|CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "%",
		mods = "SHIFT|ALT|CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "phys:Space", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{
		key = "!",
		mods = "LEADER | SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_tab()
		end),
	},
	-- We can make separate keybindings for resizing panes
	-- But Wezterm offers custom "mode" in the name of "KeyTable"
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
}

-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_pane = {
		{ key = "<", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "-", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "+", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = ">", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- Tab bar
config.use_fancy_tab_bar = false

-- config.disable_default_key_bindings = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Gnome"
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

-- Claude integration
config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

return config
