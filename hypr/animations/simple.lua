-- Simple. Minimal default-curve profile using the animationSpeed variable.
local vars = require("variables")

hl.config({ animations = { enabled = vars.animationsEnabled } })

hl.curve("specialWorkSwitch", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = vars.animationSpeed, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = vars.animationSpeed, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = vars.animationSpeed, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = vars.animationSpeed, bezier = "default" })
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 4,
    bezier = "specialWorkSwitch",
    style =
    "slidefadevert 15%"
})

hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "emphasizedAccel", style = "slide" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 5, bezier = "standard" })
