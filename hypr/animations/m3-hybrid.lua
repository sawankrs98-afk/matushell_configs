-- M3 Expressive Windows + Standard Workspaces (hybrid).
-- Bouncy expressive window open/close/move, clean standard workspace and layer
-- transitions.
local vars = require("variables")

hl.config({ animations = { enabled = vars.animationsEnabled } })

hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1 } } })
hl.curve("expressiveFastSpatial", { type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.9 } } })
hl.curve("standardSlowSpatial", { type = "bezier", points = { { 0.27, 1.06 }, { 0.18, 1 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("standardAccel", { type = "bezier", points = { { 0.3, 0 }, { 1, 1 } } })

-- Window animations (Expressive)
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "expressiveDefaultSpatial" })

-- Workspace animations (Standard)
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

-- Fade & border (Standard)
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "standard" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "standard" })

-- Layer animations (Standard)
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "standardAccel", style = "slide" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 3, bezier = "standard" })
