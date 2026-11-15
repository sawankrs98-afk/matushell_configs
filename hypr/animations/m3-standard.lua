-- M3 Standard. Clean curves without overshoot. Smooth and predictable.
local vars = require("variables")

hl.config({ animations = { enabled = vars.animationsEnabled } })

-- Spatial curves (clean, no overshoot for large-distance transitions)
hl.curve("standardDefaultSpatial", { type = "bezier", points = { { 0.27, 1.06 }, { 0.18, 1 } } })
hl.curve("standardSlowSpatial", { type = "bezier", points = { { 0.27, 1.06 }, { 0.18, 1 } } })
-- General easing curves
hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("standardDecel", { type = "bezier", points = { { 0, 0 }, { 0, 1 } } })
hl.curve("standardAccel", { type = "bezier", points = { { 0.3, 0 }, { 1, 1 } } })
-- Emphasized curves (enter/exit screen)
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })

-- Window animations
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "standardDecel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "standardAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "standardDefaultSpatial" })

-- Workspace animations
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 8,
    bezier = "standardSlowSpatial",
    style = vars.workspaceStyle,
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 4,
    bezier = "emphasizedDecel",
    style = "slidefadevert 15%",
})

-- Fade & border animations
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "standard" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "standard" })

-- Layer animations (panels, bars, tooltips)
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "standardAccel", style = "slide" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 3, bezier = "standard" })
