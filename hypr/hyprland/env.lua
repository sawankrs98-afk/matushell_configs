local vars = require("variables")

local home = os.getenv("HOME")
if home then
    local path = os.getenv("PATH") or ""
    hl.env("PATH", home .. "/.cargo/bin:" .. home .. "/.local/bin:" .. path)
end

-- Cursor
hl.env("HYPRCURSOR_THEME", tostring(vars.cursorTheme or "Bibata-Modern-Ice"))
hl.env("XCURSOR_THEME", tostring(vars.cursorTheme or "Bibata-Modern-Ice"))
hl.env("HYPRCURSOR_SIZE", tostring(vars.cursorSize or 24))
hl.env("XCURSOR_SIZE", tostring(vars.cursorSize or 24))

-- Themes
hl.env("QT_QPA_PLATFORMTHEME", "qtengine")
hl.env("QT_QPA_PLATFORMTHEME_QT6", "qtengine")
hl.env("QS_ICON_THEME", "Papirus")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Others
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- NVIDIA hardware optimization & explicit sync (ignored on non-NVIDIA systems)
hl.env("OGL_DEDICATED_HW_STATE_PER_CONTEXT", "1")
hl.env("NVD_BACKEND", "direct")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
