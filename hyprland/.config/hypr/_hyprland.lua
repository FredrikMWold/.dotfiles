-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add shared bindings in _bindings.lua
-- and computer-specific bindings in bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Load each computer's local overlays. Each file imports its shared
-- underscored base first, then applies computer-specific overrides.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other shared Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })


o.window("^(floating-terminal)$", {
	name = "windowrule-2",
	float = true,
	size = { 1200, 800 },
})

o.window("^(org\\.localsend\\.localsend_app)$", {
	name = "windowrule-localsend",
	float = true,
})

for _, app in ipairs({
	{ name = "windowrule-3", class = "chrome-teams.microsoft.com__v2_-Default" },
	{ name = "windowrule-4", class = "slack" },
	{ name = "windowrule-5", class = "net-runelite-client-RuneLite" },
	{ name = "windowrule-6", class = "com.stremio.stremio" },
	{ name = "windowrule-8", class = "discord" },
}) do
	o.window(app.class, {
		name = app.name,
		float = true,
		size = { 1400, 900 },
	})
end

for index, title in ipairs({ "^Select files$", "^Open Directory$" }) do
	o.window({ class = "vicinae", title = title }, {
		name = "windowrule-" .. tostring(index + 8),
		float = true,
		move = { "((monitor_w-window_w)/2)-700", "((monitor_h-window_h)/2)" },
	})
end

hl.layer_rule({
	name = "vicinae-blur",
	match = { namespace = "vicinae" },
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "vicinae-no-animation",
	match = { namespace = "vicinae" },
	no_anim = true,
})

o.window(".*", { opacity = "1.0 1.0" })
o.window({ tag = "floating-window" }, { size = { 1200, 800 } })
