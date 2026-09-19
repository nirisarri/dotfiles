local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local function get_ssh_args(pane)
	local info = pane:get_foreground_process_info()
	if info and info.executable and (info.executable:match("/ssh$") or info.executable:match("/devpod ssh$")) then
		return info.argv
	end
	return nil
end

local function smart_split(direction)
	return wezterm.action_callback(function(window, pane)
		pane:split({ direction = direction, args = get_ssh_args(pane) })
	end)
end

local function smart_new_tab()
	return wezterm.action_callback(function(window, pane)
		local args = get_ssh_args(pane)
		if args then
			window:perform_action(act.SpawnCommandInNewTab({ args = args }), pane)
		else
			window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
		end
	end)
end

local function smart_new_window()
	return wezterm.action_callback(function(window, pane)
		local args = get_ssh_args(pane)
		if args then
			window:perform_action(act.SpawnCommandInNewWindow({ args = args }), pane)
		else
			window:perform_action(act.SpawnWindow, pane)
		end
	end)
end

config.debug_key_events = true
config.window_close_confirmation = "NeverPrompt"
-- config.font = wezterm.font("Roboto Mono for Powerline")
-- config.font = wezterm.font("Hack Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font Propo")
config.font = wezterm.font("JetBrainsMono Nerd Font") -- ExtraLight")
-- config.font = wezterm.font("MesloLGM Nerd Font Ligaturized")
--config.font = wezterm.font("MesloLGLDZ Nerd Font Mono Ligaturized", { weight = "Medium", stretch = "Normal", style = "Normal" })

config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_load_flags = "NO_HINTING"
-- => www >= -> ===
config.font_size = 16.0
-- config.enable_tab_bar = false
-- config.window_decorations = "RESIZE"

config.color_scheme = "Tokyo Night"
--config.window_background_opacity = 0.9
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CMD",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CMD",
		action = wezterm.action.DecreaseFontSize,
	},
}
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 1500 }
config.keys = {
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "t",
		mods = "CMD",
		action = smart_new_tab(),
	},
	{
		key = "t",
		mods = "CMD|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "CMD",
		action = smart_new_window(),
	},
	{
		key = "n",
		mods = "CMD|SHIFT",
		action = act.SpawnWindow,
	},
	{
		key = "]",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "b",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "c",
		mods = "CMD|SHIFT",
		action = wezterm.action.QuickSelect,
	},
	{
		key = "raw:55", -- left CMD on most Mac keyboards
		mods = "",
		action = wezterm.action.ActivateKeyTable({
			name = "double_cmd",
			timeout_milliseconds = 500,
			one_shot = true,
		}),
	},
	{
		key = "d",
		mods = "CMD",
		action = smart_split("Right"),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = smart_split("Bottom"),
	},
	{
		key = "d",
		mods = "CMD|ALT",
		action = smart_split("Bottom"),
	},
}

config.key_tables = {
	double_cmd = {
		{
			key = "raw:55",
			mods = "",
			action = wezterm.action.QuickSelect,
		},
	},
}
return config
