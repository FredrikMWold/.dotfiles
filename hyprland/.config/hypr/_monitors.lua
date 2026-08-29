-- Shared monitor defaults. Put named outputs and machine-specific workspace
-- assignments in ~/.config/hypr/monitors.lua after importing this file.

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

for workspace = 1, 5 do
	hl.workspace_rule({ workspace = tostring(workspace), persistent = true })
end
