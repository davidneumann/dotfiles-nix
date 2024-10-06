-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Nixos fix. TODO: Remove when safe
config.front_end = "WebGpu"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

-- This is where you actually apply your config choices

-- -- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

-- config.keys = {
--   -- paste from the clipboard
--   { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
-- }

config.color_scheme = "tokyonight_night"

local launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:Ubuntu"
	config.keys = {
		{ key = "m", mods = "ALT", action = wezterm.action.ShowLauncher },
	}
	config.font = wezterm.font("MesloLGM NF")

	table.insert(launch_menu, {
		label = "PowerShell 7",
		args = { "pwsh.exe", "-NoLogo" },
		-- "C:\Program Files\PowerShell\7\pwsh.exe" -WorkingDirectory ~
		domain = { DomainName = "local" },
	})
end
config.launch_menu = launch_menu

-- Cool trick to figure out why wezterm is closing on exit when WSL breaks
-- config.exit_behavior = "CloseOnCleanExit"

config.allow_win32_input_mode = false

-- and finally, return the configuration to wezterm
return config

-- return {
-- 	font = wezterm.font 'JetBrains Mono',
-- 	color_scheme = 'Batman',
-- 	scrollback_lines = 3500,
-- }
