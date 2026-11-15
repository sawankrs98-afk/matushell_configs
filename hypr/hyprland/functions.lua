-- Shared Lua helpers

local vars = require("variables")

-- Special workspace name → window tag assigned in rules.lua. Windows carrying
-- the tag belong to that workspace, wherever they currently live.
local special_ws_tags = {
    sysmon        = "system_monitor",
    music         = "music_player",
    communication = "communication_app",
    todo          = "todo_app",
}

-- Toggle a named special workspace. Launch vars.<name>Toggle (or opts.cmd)
-- into it when no tagged window exists yet (empty/nil command = plain toggle)
local function toggle_special_workspace(name, opts)
    opts = opts or {}
    return function()
        local active = hl.get_active_special_workspace()
        local target = "special:" .. name

        -- Already shown on this monitor: just hide it
        if active and active.name == target then
            hl.dispatch(hl.dsp.workspace.toggle_special(name))
            return
        end

        local tag  = opts.tag or special_ws_tags[name]
        local cmd  = opts.cmd or vars[name .. "Toggle"]
        -- Rule-assigned tags are stored with a dynamic "*" suffix and tag
        -- queries match strictly, so the suffix must be part of the query.
        local wins = tag and hl.get_windows({ tag = tag .. "*" }) or hl.get_windows({ workspace = target })

        if #wins == 0 then
            if cmd and cmd:match("%S") then
                hl.dispatch(hl.dsp.exec_cmd(cmd, { workspace = target }))
            end
        else
            for _, win in ipairs(wins) do
                local ws = win.workspace and win.workspace.name
                if ws ~= target then
                    hl.dispatch(hl.dsp.window.move({ window = win, workspace = target, follow = false }))
                end
            end
        end

        hl.dispatch(hl.dsp.focus({ workspace = target }))
    end
end

-- Tags an array of window matches. If `field` is given, matches should be an
-- array of strings. Otherwise, it should be an array of tables.
local function tagged_rule(tag, matches, field)
    for _, match in ipairs(matches) do
        if field then
            local t = {}
            t[field] = match
            match = t
        end
        hl.window_rule({ match = match, tag = "+" .. tag })
    end
end

-- Turns a tag into a real window rule. Must run after every tagged_rule call
-- using the same tag — Hyprland matches tags in rule-registration order.
local function create_tag(tag, rules)
    local rule = { match = { tag = tag } }
    for k, v in pairs(rules) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

local function normalise_keybind(key)
    return key:gsub("%s+", ""):lower()
end

local function valid_keybind(key)
    return type(key) == "string" and key:match("%S") ~= nil
end

local function flatten_keybinds(keybinds, keys)
    keys = keys or {}

    if type(keybinds) == "table" then
        for _, keybind in pairs(keybinds) do
            flatten_keybinds(keybind, keys)
        end
    elseif valid_keybind(keybinds) then
        keys[#keys + 1] = keybinds
    end

    return keys
end

-- Bind an action to one keyspec string or an array of keyspecs.
local function create_bind(keybinds, action, flags)
    local get_flags = type(flags) == "function" and flags or function()
        return flags
    end

    for _, key in ipairs(flatten_keybinds(keybinds)) do
        hl.bind(key, action, get_flags(key))
    end
end

local function extend_keybind(base, suffix)
    return valid_keybind(base) and base .. " + " .. suffix or nil
end

-- Absolute size table sized to x/y percent of the active monitor (for resize).
local function resize_by_screen(x, y)
    local screen = hl.get_active_monitor()
    if screen and type(screen.width) == "number" and type(screen.height) == "number" then
        if not (x == 0 and y == 0) then
            local w = (x and x > 0) and math.floor(screen.width * x / 100) or screen.width
            local h = (y and y > 0) and math.floor(screen.height * y / 100) or screen.height
            return { x = w, y = h, relative = false }
        end
    end
end

-- Percentage resize action for the active window; the delta direction is
-- adjusted for tiled windows based on screen position so positive values
-- always grow the window regardless of which side of a split it resides on.
local function resize_active_window(x, y)
    return function() -- returning the function so hl reloads everytime correctly
        local win = hl.get_active_window()
        if win and win.size then
            local w = (win.size.x * (x / 100)) or 800
            local h = (win.size.y * (y / 100)) or 600

            if win.floating == false then
                local monitor = win.monitor or hl.get_active_monitor()
                if monitor and monitor.width and monitor.height then
                    local scale = monitor.scale or 1
                    local mon_center_x = (monitor.x or 0) + (monitor.width / scale / 2)
                    local mon_center_y = (monitor.y or 0) + (monitor.height / scale / 2)

                    local win_center_x = (win.at.x or 0) + (win.size.x / 2)
                    local win_center_y = (win.at.y or 0) + (win.size.y / 2)

                    if win_center_x > mon_center_x then
                        w = -w
                    end
                    if win_center_y > mon_center_y then
                        h = -h
                    end
                end
            end

            hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = true }))
        else
            hl.dispatch(hl.dsp.no_op())
        end
    end
end

local function repeating_unless_mouse(key)
    return not normalise_keybind(key):find("mouse", 1, true) and { repeating = true } or nil
end

local function wsaction(action, range, i)
    return function()
        local activews = hl.get_active_workspace()
        if not activews then return end

        local id = activews.id
        if type(id) ~= "number" or id < 1 then
            -- Named workspaces have no numbered group, fall back to the first one.
            id = 1
        end

        local slot = (id - 1) % 10 + 1
        local z = range == "group" and ((i - 1) * 10 + slot) or (math.floor((id - 1) / 10) * 10 + i)

        if action == "move" then
            return hl.dispatch(hl.dsp.window.move({ workspace = z }))
        elseif action == "move_silent" then
            return hl.dispatch(hl.dsp.window.move({ workspace = z, follow = false }))
        else
            return hl.dispatch(hl.dsp.focus({ workspace = z }))
        end
    end
end

local function move_actions(win)
    local screen = hl.get_active_monitor()

    if screen and screen.width and screen.height and win and win.size then
        local monitor_height = screen.height / (screen.scale or 1)
        local monitor_width  = screen.width / (screen.scale or 1)

        local scale_factor   = (monitor_height / 4) / win.size.y

        local target_width   = win.size.x * scale_factor
        local target_height  = win.size.y * scale_factor

        local x_resize       = math.floor(math.max(200, target_width))
        local y_resize       = math.floor(math.max(150, target_height))

        local offset         = math.min(monitor_width, monitor_height) * 0.03

        local move_x         = math.floor((screen.x or 0) + monitor_width - x_resize - offset)
        local move_y         = math.floor((screen.y or 0) + monitor_height - y_resize - offset)

        return {
            hl.dsp.window.resize({ x = x_resize, y = y_resize, window = win }),
            hl.dsp.window.move({ x = move_x, y = move_y, relative = false, window = win }),
            hl.dsp.window.set_prop({ prop = "keep_aspect_ratio", value = "true", window = win })
        }
    end
end

return {
    create_bind              = create_bind,
    toggle_special_workspace = toggle_special_workspace,
    tagged_rule              = tagged_rule,
    create_tag               = create_tag,
    extend_keybind           = extend_keybind,
    flatten_keybinds         = flatten_keybinds,
    normalise_keybind        = normalise_keybind,
    resize_by_screen         = resize_by_screen,
    resize_active_window     = resize_active_window,
    repeating_unless_mouse   = repeating_unless_mouse,
    wsaction                 = wsaction,
    move_actions             = move_actions,
}
