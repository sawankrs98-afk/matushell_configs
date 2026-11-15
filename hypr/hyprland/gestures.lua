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

-- Workspace swipe
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "horizontal", action = "workspace" })
-- Special workspace up
hl.gesture({ fingers = vars.gestureFingers or 3, direction = "up", action = "special", workspace_name = "special" })
-- Suspend (4-finger down)
hl.gesture({
    fingers   = vars.gestureFingersMore or 4,
    direction = "down",
    action    = function()
        hl.exec_cmd(vars.sleepGestureCmd or "systemctl suspend-then-hibernate")
    end,
})
