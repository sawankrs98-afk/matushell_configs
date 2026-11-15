local vars = require("variables")

hl.config({
    general = {
        layout = vars.tilingLayout,
        allow_tearing = vars.allowTearing,

        gaps_workspaces = vars.workspaceGaps,
        gaps_in = vars.windowGapsIn,
        gaps_out = vars.windowGapsOut,
        border_size = vars.windowBorderSize,

        col = {
            active_border = vars.activeWindowBorderColour,
            inactive_border = vars.inactiveWindowBorderColour,
        },
    },

    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = true,
    },

    master = {
        mfact = 0.5,
    },

    scrolling = {
        fullscreen_on_one_column = true,
        focus_fit_method = 0,
        column_width = 1.0,
        follow_focus = true,
        follow_min_visible = 0.0,
        explicit_column_widths = "0.35, 0.5, 0.65, 1.0",
    },
})
