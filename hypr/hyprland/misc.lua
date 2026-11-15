local vars   = require("variables")
local ok, scheme = pcall(require, "scheme.current")
if not ok or type(scheme) ~= "table" then
    scheme = require("scheme.default")
end

hl.config({
    misc = {
        animate_manual_resizes       = false,
        animate_mouse_windowdragging = false,

        disable_hyprland_logo        = true,
        force_default_wallpaper      = 0,

        on_focus_under_fullscreen    = 2,
        allow_session_lock_restore   = true,
        middle_click_paste           = false,
        focus_on_activate            = true,
        session_lock_xray            = true,

        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,

        background_color             = "rgb(" .. scheme.surfaceContainer .. ")",
    },

    render = {
        new_render_scheduling = true,
        direct_scanout        = vars.directScanout,
    },

    debug = {
        error_position = 1,
    },
})
