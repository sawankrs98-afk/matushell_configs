-- M3 Expressive. Bouncy spatial curves with overshoot settle.
local vars = require("variables")

hl.config({ animations = { enabled = vars.animationsEnabled } })

hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1 } } })
hl.curve("expressiveFastSpatial", { type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.9 } } })
hl.curve("expressiveSlowSpatial", { type = "bezier", points = { { 0.39, 1.29 }, { 0.35, 0.98 } } })
hl.curve("expressiveDefaultEffects", { type = "bezier", points = { { 0.34, 0.80 }, { 0.34, 1 } } })
hl.curve("expressiveFastEffects", { type = "bezier", points = { { 0.31, 0.94 }, { 0.34, 1 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })

-- Window animations
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "expressiveDefaultSpatial" })

-- Workspace animations
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "expressiveSlowSpatial",
    style = vars.workspaceStyle,
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 5,
    bezier = "expressiveDefaultSpatial",
    style = "slidefadevert 15%",
})

-- Fade & border animations
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "expressiveDefaultEffects" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "expressiveFastEffects" })

-- Layer animations (panels, bars, tooltips)
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "emphasizedAccel", style = "slide" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 2, bezier = "expressiveDefaultEffects" })
