local vars = require("variables")
local fn   = require("hyprland.functions")

-- All tags
local opaque_tag = "opaque"
local float_tag = "float"
local float_50_60_tag = "float_50_60"
local float_60_70_tag = "float_60_70"
local float_70_80_tag = "float_70_80"
local xwl_popup_tag = "xwl_popup"
local system_monitor_tag = "system_monitor"
local music_player_tag = "music_player"
local communication_app_tag = "communication_app"
local todo_app_tag = "todo_app"

----------------------
---- Window rules ----
----------------------

-- Fullscreen windows are never translucent
hl.window_rule({ match = { fullscreen = true }, opacity = "1.0 override" })

-- opacity mode: single (opacitySingleMode == 1). Split mode (0) adds nothing.
if (vars.opacitySingleMode or 0) == 1 then
    hl.window_rule({ match = { fullscreen = false }, opacity = (vars.singleWindowOpacity or 1) .. " override" })
end

-- Center all floating windows (not xwayland cause popups)
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

-- Picture in picture
hl.window_rule({
    match = { title = "^Picture[- ]in[- ][Pp]icture$" },
    move = "100%-w-2% 100%-w-3%",
    keep_aspect_ratio = true,
    float = true,
    pin = true,
})

----------------------
---- Tagged rules ----
----------------------

-- Opaque apps
fn.tagged_rule(opaque_tag, {
    "org.quickshell",                -- Quickshell
    "imv|swappy",                    -- Image viewers
    "krita|gimp|inkscape|darktable", -- Image editors
    "mpv|org.gnome.Showtime",        -- Video viewers
    "resolve|kdenlive|shotcut",      -- Video editors
    "blender|godot",                 -- 3D editors
}, "class")

-- Floating apps
fn.tagged_rule(float_tag, {
    "guifetch",                           -- System info
    "yad|zenity",                         -- Dialogs
    "wev",                                -- Input detector
    "org.gnome.FileRoller|file-roller",   -- Archive manager
    "blueman-manager",                    -- Bluetooth GUI
    "com.github.GradienceTeam.Gradience", -- GTK themer (deprecated)
    "feh|imv",                            -- Image viewers
    "org.quickshell",                     -- Quickshell
}, "class")
fn.tagged_rule(float_tag, {
    "File (Operation|Upload)( Progress)?", -- File manager operation progress
    ".* Properties",                       -- File properties
    '^Rename( ".*")?$',                    -- File rename dialogs
    "Export Image as PNG",                 -- GIMP export
    "GIMP Crash Debug",                    -- GIMP crash dialog
}, "title")

-- Sized floaters
-- 50% x 60%
fn.tagged_rule(float_50_60_tag, {
    "nwg-look",              -- GTK theme manager
    "system-config-printer", -- Printer config
}, "class")
-- 60% x 70%
fn.tagged_rule(float_60_70_tag, {
    "(Select|Open)( a)? (File|Folder)(s)?", -- File dialogs
    "Save As",                              -- Save dialogs
    "Library",                              -- Save dialogs (some apps)
}, "title")
fn.tagged_rule(float_60_70_tag, {
    "org.pulseaudio.pavucontrol|yad-icon-browser", -- Audio control / GTK icon browser
}, "class")
fn.tagged_rule(float_60_70_tag, {
    { class = "foot", title = "nmtui" }, -- Network manager TUI
})
-- 70% x 80%
fn.tagged_rule(float_70_80_tag, {
    "org.gnome.Settings", -- System settings
}, "class")

-- Xwayland popups
fn.tagged_rule(xwl_popup_tag, {
    { xwayland = true, title = "win[0-9]+" },
    { xwayland = true, title = "",         class = "", initial_title = "", initial_class = "" },
})

-- Special workspaces
fn.tagged_rule(system_monitor_tag, { "btop" }, "class")
fn.tagged_rule(music_player_tag, {
    "feishin|Spotify|Supersonic|Cider|Plexamp",                    -- Native players
    "com.github.th_ch.youtube_music|com-maxrave-simpmusic-MainKt", -- Web players
}, "class")
fn.tagged_rule(music_player_tag, {
    "Spotify( Free)?|Youtube Music", -- Spotify wayland has no class for some reason
}, "initial_title")
fn.tagged_rule(communication_app_tag, {
    "discord|equibop|vesktop|whatsapp", -- Chat clients
}, "class")
fn.tagged_rule(todo_app_tag, {
    "Todoist|obsidian", -- Todo apps
}, "class")
fn.tagged_rule(todo_app_tag, {
    "Obsidian", -- Obsidian wayland
}, "initial_title")

-----------------------
---- Per app rules ----
-----------------------

-- Sized floaters with literal sizes
hl.window_rule({ match = { class = "waypaper" }, float = true })
hl.window_rule({ match = { class = "waypaper" }, size = "800 600" })
hl.window_rule({ match = { class = "waypaper" }, center = true })

-- Polkit
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, center = true })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, pin = true })

-- Force tiling on apps that float themselves
hl.window_rule({ match = { class = "^(org\\.wezfurlong\\.wezterm)$" }, tile = true })
hl.window_rule({ match = { class = "^(gnome-control-center)$" }, tile = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, tile = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, tile = true })

-- GNOME rounding
hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, rounding = 12 })

-- Steam
hl.window_rule({ match = { class = "^(steam)$" }, rounding = 10 })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts)" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts)" }, pin = true })

-------------------------
---- Tag definitions ----
-------------------------
-- These have to come after all uses of window tagging. Thank you Hyprland...

fn.create_tag(opaque_tag, { opaque = true })
fn.create_tag(float_tag, { float = true })
fn.create_tag(float_50_60_tag, { float = true, size = "(monitor_w*0.5) (monitor_h*0.6)", center = true })
fn.create_tag(float_60_70_tag, { float = true, size = "(monitor_w*0.6) (monitor_h*0.7)", center = true })
fn.create_tag(float_70_80_tag, { float = true, size = "(monitor_w*0.7) (monitor_h*0.8)", center = true })
fn.create_tag(xwl_popup_tag, {
    no_dim = true,
    no_shadow = true,
    no_blur = true,
    opaque = true,
    rounding = math.min(10, vars.windowRounding or 10), -- Popups are usually small, so we want to limit the rounding
})
fn.create_tag(system_monitor_tag, { workspace = "special:sysmon" })
fn.create_tag(music_player_tag, { workspace = "special:music" })
fn.create_tag(communication_app_tag, { workspace = "special:communication" })
fn.create_tag(todo_app_tag, { workspace = "special:todo" })

-------------------------
---- Workspace rules ----
-------------------------

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = vars.singleWindowGapsOut or 12 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = vars.singleWindowGapsOut or 12 })
