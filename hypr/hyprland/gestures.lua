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

-- Three-finger vertical workspace navigation.
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "up", action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "-1" }))
end })
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "down", action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "+1" }))
end })
-- Three-finger horizontal focus follows the scrolling column layout.
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "left", action = function()
    hl.dispatch(hl.dsp.focus({ direction = "l" }))
end })
hl.gesture({ fingers = vars.workspaceSwipeFingers or 3, direction = "right", action = function()
    hl.dispatch(hl.dsp.focus({ direction = "r" }))
end })
