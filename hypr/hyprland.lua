-- Hyprland Lua configuration entry point.
-- Order: scheme bootstrap → variables (with user overrides) → core modules →
-- matushell shell module → user free config.
local home = os.getenv("HOME")
local hypr = home .. "/.config/hypr"
package.path = package.path .. ";" .. hypr .. "/?.lua"

-- Create a file if it doesn't exist, optionally with initial content
local function maybe_create(file, content)
    local f = io.open(file)

    if f then
        f:close()
        return
    end

    f = io.open(file, "w")
    if f then
        if content then f:write(content) end
        f:close()
    end
end

-- Copy src to dst, but only if dst doesn't already exist
local function maybe_copy(src, dst)
    local out = io.open(dst)
    if out then
        out:close()
        return
    end

    local input = io.open(src, "r")
    if not input then return end

    out = io.open(dst, "w")
    if out then
        out:write(input:read("*a"))
        out:close()
    end
    input:close()
end

-- Ensure current colours file exists and is valid Lua; restore default if missing or corrupted
local function ensure_scheme()
    local ok_scheme = false
    local chunk, err = loadfile(hypr .. "/scheme/current.lua")
    if chunk and not err then
        ok_scheme = true
    end
    if not ok_scheme then
        local def = io.open(hypr .. "/scheme/default.lua", "r")
        if def then
            local content = def:read("*a")
            def:close()
            local cur = io.open(hypr .. "/scheme/current.lua", "w")
            if cur then
                cur:write(content)
                cur:close()
            end
        end
    end
end
ensure_scheme()

-- User variable overrides, merged over the defaults in variables.lua
maybe_create(hypr .. "/user/variables.lua", "return {}\n")
local overrides = require("user.variables")
if type(overrides) == "table" then
    local vars = require("variables")
    for k, v in pairs(overrides) do
        vars[k] = v
    end
end

-- Default monitor conf. Add your own hl.monitor() calls in user/hyprland.lua.
hl.monitor({
    output   = "",
    mode     = "highrr",
    position = "0x0",
    scale    = 1
})

-- Core modules (order matters: settings before binds/rules)
require("hyprland.functions")
require("hyprland.env")
require("hyprland.general")
require("hyprland.input")
require("hyprland.decoration")
require("hyprland.group")
require("hyprland.misc")
require("hyprland.gestures")
require("hyprland.animations")
require("hyprland.execs")
require("hyprland.rules")
require("hyprland.keybinds")

-- Shell module (matushell)
require("shell.matus")

-- User free config: monitors, extra binds/rules, anything you want
maybe_create(
    hypr .. "/user/hyprland.lua",
    '-- Free-form Hyprland config. Loaded after every core module.\n'
        .. 'local vars   = require("variables")\n'
        .. 'local scheme = require("scheme.current")\n'
        .. 'local fn     = require("hyprland.functions")\n'
)
require("user.hyprland")
