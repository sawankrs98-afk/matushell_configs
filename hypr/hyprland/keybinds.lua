-- Core keybinds. matushell-specific globals
-- live in shell/matus.lua.
local vars             = require("variables")
local fn               = require("hyprland.functions")

-- Flags
local locked           = { locked = true }
local repeating        = { repeating = true }
local locked_repeating = { locked = true, repeating = true }

--- App launches ---
fn.create_bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal or "kitty"))
fn.create_bind(vars.kbBrowser, hl.dsp.exec_cmd(vars.browser or "zen-browser"))
fn.create_bind(vars.kbEditor, hl.dsp.exec_cmd(vars.editor or "code"))
fn.create_bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer or "dolphin"))
if vars.kbAudioSettings and vars.audioSettings then
    fn.create_bind(vars.kbAudioSettings, hl.dsp.exec_cmd(vars.audioSettings))
end
fn.create_bind(vars.kbSmartFloat, function()
    local win = hl.get_active_window()
    if not win then
        return
    end
    if win.floating then
        -- Floating → tile
        hl.dispatch(hl.dsp.window.float({ action = "disable" }))
    else
        -- Tiled → float, resize to 900×600, center
        hl.dispatch(hl.dsp.window.float({ action = "enable" }))
        hl.dispatch(hl.dsp.window.resize({ x = 900, y = 600, relative = false }))
        hl.dispatch(hl.dsp.window.center())
    end
end)

--- Picture-in-Picture ---
if vars.kbWindowPip then
    fn.create_bind(vars.kbWindowPip, function()
        local a = hl.get_active_window()
        if a then
            local pip = fn.move_actions(a) or {}
            if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
            table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))
            for _, x in ipairs(pip) do
                hl.dispatch(x)
            end
        end
    end)
end

--- Window management ---
fn.create_bind(vars.kbCloseWindow, hl.dsp.window.close())
fn.create_bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
fn.create_bind(vars.kbWindowMaximized, hl.dsp.window.fullscreen({ mode = "maximized" }))
fn.create_bind(vars.kbToggleColumnWidth, hl.dsp.layout("colresize +conf"))
fn.create_bind(vars.kbToggleSplit, hl.dsp.layout("togglesplit"))
fn.create_bind(vars.kbToggleGroup, hl.dsp.group.toggle())

fn.create_bind(vars.kbWindowMoveLeft, hl.dsp.window.move({ direction = "l" }))
fn.create_bind(vars.kbWindowMoveDown, hl.dsp.window.move({ direction = "d" }))
fn.create_bind(vars.kbWindowMoveUp, hl.dsp.window.move({ direction = "u" }))
fn.create_bind(vars.kbWindowMoveRight, hl.dsp.window.move({ direction = "r" }))

-- Mouse move/resize
fn.create_bind(vars.kbMouseMove, hl.dsp.window.drag(), { desc = "Move window" })
fn.create_bind(vars.kbMouseResize, hl.dsp.window.resize(), { desc = "Resize window" })

--- Window groups ---
fn.create_bind(vars.kbWindowCycleNext, hl.dsp.window.cycle_next(), repeating)
fn.create_bind(vars.kbWindowCyclePrev, hl.dsp.window.cycle_next({ next = false }), repeating)
if vars.kbWindowGroupCycleNext then
    fn.create_bind(vars.kbWindowGroupCycleNext, hl.dsp.group.next(), repeating)
end
if vars.kbWindowGroupCyclePrev then
    fn.create_bind(vars.kbWindowGroupCyclePrev, hl.dsp.group.prev(), repeating)
end
if vars.kbGroupNext then
    fn.create_bind(vars.kbGroupNext, hl.dsp.group.next(), repeating)
end
if vars.kbGroupPrev then
    fn.create_bind(vars.kbGroupPrev, hl.dsp.group.prev(), repeating)
end
fn.create_bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }))
fn.create_bind(vars.kbGroupLockActive, hl.dsp.group.lock())

--- Window actions ---
fn.create_bind(vars.kbPinWindow, hl.dsp.window.pin())
fn.create_bind(vars.kbMoveWindow, hl.dsp.window.drag())
fn.create_bind(vars.kbResizeWindow, hl.dsp.window.resize())
fn.create_bind(vars.kbCenterWindow, hl.dsp.window.center())
fn.create_bind(vars.kbNormalizeWindow, function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
    hl.dispatch(hl.dsp.window.center())
end)

--- Focus ---
fn.create_bind(vars.kbFocusLeft, hl.dsp.focus({ direction = "l" }))
fn.create_bind(vars.kbFocusDown, hl.dsp.focus({ direction = "d" }))
fn.create_bind(vars.kbFocusUp, hl.dsp.focus({ direction = "u" }))
fn.create_bind(vars.kbFocusRight, hl.dsp.focus({ direction = "r" }))
fn.create_bind(vars.kbFocusLastWindow, hl.dsp.focus({ window = "last" }))
fn.create_bind(vars.kbFocusFirstWindow, hl.dsp.focus({ window = "first" }))

--- Resize (percent via dynamic helpers; pixel via native relative delta) ---
fn.create_bind(vars.kbWindowIncreaseWidth, fn.resize_active_window(10, 0), repeating)
fn.create_bind(vars.kbWindowDecreaseWidth, fn.resize_active_window(-10, 0), repeating)
fn.create_bind(vars.kbWindowDecreaseHeight, fn.resize_active_window(0, -10), repeating)
fn.create_bind(vars.kbWindowIncreaseHeight, fn.resize_active_window(0, 10), repeating)
fn.create_bind(
    vars.kbWindowExpandLeft,
    hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
    { desc = "Expand window left" }
)
fn.create_bind(
    vars.kbWindowShrinkLeft,
    hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
    { desc = "Shrink window left" }
)
fn.create_bind(vars.kbWindowFillScreen, function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_by_screen(100, 100)))
end)

--- Workspaces (1 to 10 with workspace group support) ---
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    fn.create_bind(fn.extend_keybind(vars.kbGoToWs, key), fn.wsaction("focus", "", i))
    fn.create_bind(fn.extend_keybind(vars.kbMoveWinToWs, key), fn.wsaction("move", "", i))
    if vars.kbGoToWsGroup then
        fn.create_bind(fn.extend_keybind(vars.kbGoToWsGroup, key), fn.wsaction("focus", "group", i))
    end
    if vars.kbMoveWinToWsGroup then
        fn.create_bind(fn.extend_keybind(vars.kbMoveWinToWsGroup, key), fn.wsaction("move", "group", i))
    end
    if vars.kbMoveWinToWsSilent then
        fn.create_bind(fn.extend_keybind(vars.kbMoveWinToWsSilent, key), fn.wsaction("move_silent", "", i))
    end
end

--- Workspace navigation ---
fn.create_bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), fn.repeating_unless_mouse)
fn.create_bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), fn.repeating_unless_mouse)
if vars.kbNextWsGroup then
    fn.create_bind(vars.kbNextWsGroup, hl.dsp.focus({ workspace = "+10" }), fn.repeating_unless_mouse)
end
if vars.kbPrevWsGroup then
    fn.create_bind(vars.kbPrevWsGroup, hl.dsp.focus({ workspace = "-10" }), fn.repeating_unless_mouse)
end
fn.create_bind(vars.kbMoveWinToWsNext, hl.dsp.window.move({ workspace = "+1" }), fn.repeating_unless_mouse)
fn.create_bind(vars.kbMoveWinToWsPrev, hl.dsp.window.move({ workspace = "-1" }), fn.repeating_unless_mouse)
if vars.kbCycleNextWs then
    fn.create_bind(vars.kbCycleNextWs, hl.dsp.focus({ workspace = "e+1" }), fn.repeating_unless_mouse)
end
if vars.kbCyclePrevWs then
    fn.create_bind(vars.kbCyclePrevWs, hl.dsp.focus({ workspace = "e-1" }), fn.repeating_unless_mouse)
end
if vars.kbToggleLastWorkspace then
    fn.create_bind(vars.kbToggleLastWorkspace, hl.dsp.focus({ workspace = "previous" }))
end

--- Monitor focus/move ---
fn.create_bind(vars.kbFocusMonitorLeft, hl.dsp.focus({ monitor = "l" }))
fn.create_bind(vars.kbFocusMonitorDown, hl.dsp.focus({ monitor = "d" }))
fn.create_bind(vars.kbFocusMonitorUp, hl.dsp.focus({ monitor = "u" }))
fn.create_bind(vars.kbFocusMonitorRight, hl.dsp.focus({ monitor = "r" }))
fn.create_bind(vars.kbMoveMonitorLeft, hl.dsp.window.move({ monitor = "l" }))
fn.create_bind(vars.kbMoveMonitorDown, hl.dsp.window.move({ monitor = "d" }))
fn.create_bind(vars.kbMoveMonitorUp, hl.dsp.window.move({ monitor = "u" }))
fn.create_bind(vars.kbMoveMonitorRight, hl.dsp.window.move({ monitor = "r" }))

--- Layout ---
fn.create_bind(vars.kbPreselectLeft, hl.dsp.layout("preselect l"))
fn.create_bind(vars.kbPreselectRight, hl.dsp.layout("preselect r"))

--- Special workspaces (toggle + launch their app) ---
fn.create_bind(vars.kbSystemMonitorWs, fn.toggle_special_workspace("sysmon"))
fn.create_bind(vars.kbMusicWs, fn.toggle_special_workspace("music"))
fn.create_bind(vars.kbCommunicationWs, fn.toggle_special_workspace("communication"))
fn.create_bind(vars.kbTodoWs, fn.toggle_special_workspace("todo"))
fn.create_bind(vars.kbSpecialWs, hl.dsp.workspace.toggle_special("special"))
fn.create_bind(vars.kbMoveWinToWsSpecial, hl.dsp.window.move({ workspace = "special:special" }))
fn.create_bind(vars.kbMoveWinFromWsSpecial, hl.dsp.window.move({ workspace = "e+0" }))
fn.create_bind(vars.kbMoveWinToSysmon, hl.dsp.window.move({ workspace = "special:sysmon" }))
fn.create_bind(vars.kbMoveWinToMusic, hl.dsp.window.move({ workspace = "special:music" }))
fn.create_bind(vars.kbMoveWinToCommunication, hl.dsp.window.move({ workspace = "special:communication" }))
fn.create_bind(vars.kbMoveWinToTodo, hl.dsp.window.move({ workspace = "special:todo" }))

--- Media ---
if vars.kbMediaToggle then
    fn.create_bind(vars.kbMediaToggle, hl.dsp.exec_cmd("playerctl play-pause"), locked)
end
if vars.kbMediaNext then
    fn.create_bind(vars.kbMediaNext, hl.dsp.exec_cmd("playerctl next"), locked)
end
if vars.kbMediaPrev then
    fn.create_bind(vars.kbMediaPrev, hl.dsp.exec_cmd("playerctl previous"), locked)
end
if vars.kbMediaStop then
    fn.create_bind(vars.kbMediaStop, hl.dsp.exec_cmd("playerctl stop"), locked)
end

--- Volume ---
fn.create_bind(vars.kbMicMute, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
fn.create_bind(vars.kbVolumeMute, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
fn.create_bind(
    vars.kbVolumeUp,
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ " ..
        (vars.volumeStep or 5) .. "%+"
    ),
    locked_repeating
)
fn.create_bind(
    vars.kbVolumeDown,
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. (vars.volumeStep or 5) .. "%-"
    ),
    locked_repeating
)

--- System ---
fn.create_bind(vars.kbSwitchKeyboardLayout, hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))
fn.create_bind(vars.kbSuspend, hl.dsp.exec_cmd("systemctl suspend"), locked)
if vars.kbSleep then
    fn.create_bind(vars.kbSleep, hl.dsp.exec_cmd(vars.sleepGestureCmd or "systemctl suspend-then-hibernate"), locked)
end
