-- Free-form Hyprland config. Loaded after every core module and the matushell
-- shell module, so anything goes here: monitors, extra window rules, your own
-- hl.bind() calls, per-machine workarounds, etc.
local vars   = require("variables")
local ok, scheme = pcall(require, "scheme.current")
if not ok or type(scheme) ~= "table" then
    scheme = require("scheme.default")
end
local fn     = require("hyprland.functions")
--
-- Examples:
--
-- hl.monitor({
--     output   = "DP-1",
--     mode     = "2560x1440@165",
--     position = "0x0",
--     scale    = 1,
--     vrr      = 2
-- })
--
-- hl.window_rule({ match = { class = "some-app" }, float = true })
-- hl.bind("SUPER + F12", hl.dsp.exec_cmd("notify-send 'hi'"))
