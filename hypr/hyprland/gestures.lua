local vars = require("variables")

hl.config({
    gestures = {
        workspace_swipe_distance                 = 700,
        workspace_swipe_cancel_ratio             = 0.15,
        workspace_swipe_min_speed_to_force       = 5,
        workspace_swipe_direction_lock           = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new               = true,
        scrolling = {
            move_snap_to_grid = false,
            move_snap_cursor = false,
        },
    },
})

-- Workspace switching follows the vertical scrolling direction.
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "vertical", action = "workspace" })
-- Advance exactly one column per swipe, regardless of swipe distance or speed.
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "left", action = function()
    hl.dispatch(hl.dsp.layout("focus r"))
end })
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "right", action = function()
    hl.dispatch(hl.dsp.layout("focus l"))
end })
