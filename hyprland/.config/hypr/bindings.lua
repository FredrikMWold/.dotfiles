-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

local function open_or_move_to_scratchpad(window_name, launch_command)
	local normalized_name = window_name:lower()

	return function()
		local matching_window
		for _, window in ipairs(hl.get_windows()) do
			if window.class:lower() == normalized_name or window.title:lower() == normalized_name then
				matching_window = window
				break
			end
		end

		if not matching_window then
			hl.dispatch(hl.dsp.exec_cmd(launch_command))
			return
		end

		local active_monitor = hl.get_active_monitor()
		local active_workspace = active_monitor and active_monitor.active_workspace
		if not active_workspace then
			return
		end

		if matching_window.workspace == active_workspace then
			hl.dispatch(hl.dsp.window.move({ workspace = "special", window = matching_window, follow = false }))
			return
		end

		hl.dispatch(hl.dsp.window.move({ workspace = active_workspace, window = matching_window }))
		hl.dispatch(hl.dsp.focus({ window = matching_window }))
		hl.dispatch(hl.dsp.window.move({ monitor = active_monitor, window = matching_window }))
		hl.dispatch(hl.dsp.window.center({ window = matching_window }))
	end
end

for _, keys in ipairs({
	"SUPER + SHIFT + F",
	"SUPER + SHIFT + M",
	"SUPER + SHIFT + ALT + M",
	"SUPER + SHIFT + N",
	"SUPER + SHIFT + D",
	"SUPER + SHIFT + O",
	"SUPER + SHIFT + W",
	"SUPER + ALT + SPACE",
	"SUPER + CTRL + E",
	"CTRL + ALT + DELETE",
	"SUPER + ALT + LEFT",
	"SUPER + ALT + RIGHT",
	"SUPER + SPACE",
	"SUPER + CTRL + V",
	"SUPER + P",
	"SUPER + T",
	"SUPER + S",
	"SUPER + L",
	"SUPER + K",
	"SUPER + comma",
	"SUPER + LEFT",
	"SUPER + RIGHT",
	"SUPER + SHIFT + ALT + LEFT",
	"SUPER + SHIFT + ALT + RIGHT",
	"SUPER + RETURN",
}) do
	hl.unbind(keys)
end

o.bind("SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")
o.bind("SUPER + B", "Browser", "omarchy-launch-browser")
o.bind("SUPER + ALT + B", "Browser (private)", "omarchy-launch-browser --private")
o.bind("SUPER + SHIFT + M", "Music", "omarchy-launch-or-focus spotify")
o.bind("SUPER + SHIFT + ALT + M", "Music TUI", "omarchy-launch-or-focus-tui cliamp")
o.bind("SUPER + SHIFT + N", "Editor", "omarchy-launch-editor")
o.bind("SUPER + SHIFT + T", "Activity", "omarchy-launch-tui btop")
o.bind("SUPER + SHIFT + D", "Docker", "omarchy-launch-tui lazydocker")
o.bind("SUPER + SHIFT + O", "Obsidian", 'omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"')
o.bind("SUPER + SHIFT + W", "Typora", "uwsm-app -- typora --enable-wayland-ime")
o.bind("SUPER + A", "ChatGPT", 'omarchy-launch-webapp "https://chatgpt.com"')
o.bind("SUPER + Y", "YouTube", 'omarchy-launch-webapp "https://youtube.com/"')

o.bind("SUPER + ALT + LEFT", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + ALT + RIGHT", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + LEFT", "Move window left", hl.dsp.window.move({ direction = "l" }))
o.bind("SUPER + RIGHT", "Move window right", hl.dsp.window.move({ direction = "r" }))

o.bind("SUPER + ALT + mouse:272", nil, hl.dsp.window.float({ action = "set" }))
o.bind("SUPER + ALT + mouse:272", "Float and move window", hl.dsp.window.drag(), { mouse = true })
o.bind("SUPER + ALT + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

o.bind("SUPER + SHIFT + ALT + LEFT", "Move window to previous workspace", hl.dsp.window.move({ workspace = "e-1" }))
o.bind("SUPER + SHIFT + ALT + RIGHT", "Move window to next workspace", hl.dsp.window.move({ workspace = "e+1" }))

o.bind("CTRL + ALT + DELETE", "Process manager", "vicinae cmd launch @leonkohli/store.vicinae.process-manager:processes")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", "omarchy menu")
o.bind("SUPER + CTRL + E", "Emoji picker", "vicinae cmd launch core:search-emojis")
o.bind("SUPER + P", "Password menu", "vicinae cmd launch @fredrikmwold/hyprland-monitors:configure-monitors")
o.bind("SUPER + CTRL + V", "Clipboard menu", "vicinae cmd launch clipboard:history")
o.bind("SUPER + K", "Hotkeys help", "vicinae cmd launch @tinkerbells/store.vicinae.pass:pass")
o.bind("SUPER + R", "Radix TUI", "vicinae cmd launch @FredrikMWold/radix:pipeline-jobs")
o.bind("SUPER + SPACE", "Launcher", "vicinae toggle")

o.bind("SUPER + T", "Floating Teams",
	open_or_move_to_scratchpad("teams-for-linux", "uwsm-app -- /opt/teams-for-linux/teams-for-linux"))
o.bind("SUPER + S", "Floating Slack", open_or_move_to_scratchpad("slack", "uwsm-app -- slack"))
o.bind("SUPER + D", "Floating Discord", open_or_move_to_scratchpad("discord", "uwsm-app -- discord"))
o.bind("SUPER + RETURN", "Terminal",
	open_or_move_to_scratchpad("floating-terminal", "uwsm-app -- kitty --class floating-terminal"))
o.bind("SUPER + L", "Lock screen", "omarchy-system-lock")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
