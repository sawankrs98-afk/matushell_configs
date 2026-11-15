local vars = require("variables")

hl.config({
    gestures = {
        workspace_swipe_distance                 = 700,
        workspace_swipe_cancel_ratio             = 0.15,
        workspace_swipe_min_speed_to_force       = 5,
        workspace_swipe_direction_lock           = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new               = true,
    },
})

-- Workspace switching follows the vertical scrolling direction.
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "vertical", action = "workspace" })
-- Scroll horizontally through the columns in the active workspace.
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "left", action = "scroll_move" })
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "right", action = "scroll_move" })
