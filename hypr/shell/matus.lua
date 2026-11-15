-- Matushell shell module: layer rules + global shortcut binds.
local vars             = require("variables")
local fn               = require("hyprland.functions")

-- Flags
local locked           = { locked = true }
local release          = { release = true }
local locked_repeating = { locked = true, repeating = true }

---- Layer rules ----
hl.layer_rule({ match = { namespace = "^matushell:.*" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^skwd-paper.*" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^skwd-wall.*" }, no_anim = true })
hl.layer_rule({ name = "matushell-blur", match = { namespace = "^matushell:.*" }, blur = false, ignore_alpha = 0.0 })
hl.layer_rule({
    match = { namespace = "^matushell:(reservation|wallpaper|screencorners|bgwidgets|snip|colorpicker|notifimagecache|adaptiveshadow)$" },
    blur = false,
})

---- Panels ----
fn.create_bind(vars.kbHub, hl.dsp.global("matushell:hub"))
fn.create_bind(vars.kbNotifications, hl.dsp.global("matushell:notificationPanel"))
fn.create_bind(vars.kbControlCenter, hl.dsp.global("matushell:controlCenter"))
fn.create_bind(vars.kbLock, hl.dsp.global("matushell:lock"))
fn.create_bind(vars.kbPowerMenu, hl.dsp.global("matushell:powerMenu"))

-- Launcher fires on Super + Space
fn.create_bind(vars.kbLauncher, hl.dsp.global("matushell:launcher"))

---- Popouts & toggles ----
fn.create_bind(vars.kbMediaPlayer, hl.dsp.global("matushell:mediaPlayer"))
fn.create_bind(vars.kbSystemMonitor, hl.dsp.global("matushell:systemMonitor"))
fn.create_bind(vars.kbToggleDnd, hl.dsp.exec_cmd("matus dnd toggle"))
fn.create_bind(vars.kbToggleGamemode, hl.dsp.global("matushell:toggleGamemode"))
fn.create_bind(vars.kbToggleKeepAwake, hl.dsp.exec_cmd("matus keepawake toggle"))
fn.create_bind(vars.kbThemeToggle, hl.dsp.global("matushell:themeToggle"))
fn.create_bind(vars.kbWallpaperCarousel, hl.dsp.global("matushell:wallpaperCarousel"))

---- Clipboard & emoji ----
fn.create_bind(vars.kbClipboard, hl.dsp.global("matushell:clipboard"))
fn.create_bind(vars.kbEmojiPicker, hl.dsp.global("matushell:emoji"))

---- Capture ----
fn.create_bind(vars.kbColorPicker, hl.dsp.global("matushell:colorPicker"))
fn.create_bind(vars.kbScreenshotRegion, hl.dsp.global("matushell:screenshotRegion"))
fn.create_bind(vars.kbScreenshotFullscreen, hl.dsp.global("matushell:screenshotFullscreenNow"), locked)
fn.create_bind(vars.kbRecordFullscreen, hl.dsp.global("matushell:recordFullscreenNow"))

---- Brightness / volume via the shell OSD ----
fn.create_bind(vars.kbBrightnessUp, hl.dsp.global("matushell:brightnessUp"), locked_repeating)
fn.create_bind(vars.kbBrightnessDown, hl.dsp.global("matushell:brightnessDown"), locked_repeating)
fn.create_bind(vars.kbShellVolumeUp, hl.dsp.global("matushell:volumeUp"), locked_repeating)
fn.create_bind(vars.kbShellVolumeDown, hl.dsp.global("matushell:volumeDown"), locked_repeating)
