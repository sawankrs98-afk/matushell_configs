-- All variables
local ok, scheme = pcall(require, "scheme.current")
if not ok or type(scheme) ~= "table" then
    ok, scheme = pcall(require, "scheme.default")
    if not ok or type(scheme) ~= "table" then
        scheme = {}
    end
end

-- Fallback color helper in case a token is missing in the scheme
local function col(name, fallback)
    return (type(scheme) == "table" and scheme[name]) or fallback
end

return {
    ------------------
    ---- HYPRLAND ----
    ------------------

    -- Apps
    terminal = "kitty",
    browser = "zen-browser",
    editor = "code",
    fileExplorer = "dolphin",
    audioSettings = "pwvucontrol",

    -- Special workspace apps
    sysmonToggle = "foot -a btop -T btop fish -C btop",
    musicToggle = "spicetify watch -s",
    communicationToggle = "vesktop",
    todoToggle = "obsidian",

    -- Modifiers, handy for composing keyspecs
    mainMod = "SUPER",
    superMod = "SUPER",

    -- Keyboard
    kbLayout = "us",

    -- Cursor
    cursorTheme = "Bibata-Modern-Ice",
    cursorSize = 26,

    -- Blur
    blurEnabled = true,
    blurSpecialWs = false,
    blurPopups = true,
    blurInputMethods = true,
    blurSize = 10,
    blurPasses = 3,
    blurXray = false,
    blurNoise = 0.04,
    blurBrightness = 1,
    blurContrast = 0.89,
    blurVibrancy = 0.2,
    blurVibrancyDark = 0.2,

    -- Motion blur
    motionBlurEnabled = false,
    motionBlurSamples = 7,

    -- Wobble
    wobbleEnabled = true,
    wobbleMesh = 12,
    wobbleStiffness = 280,
    wobbleDamping = 20,
    wobbleMass = 1,
    wobbleIntensity = 0.15,
    wobbleValueEp = 0.2,
    wobbleVelocityEp = 0.2,

    -- Shadow
    shadowEnabled = true,
    shadowRange = 25,
    shadowRenderPower = 4,
    shadowColour = "rgba(" .. col("shadow", "000000") .. "50)",
    shadowOffset = "0 0",

    -- Gaps
    workspaceGaps = 20,
    windowGapsIn = 5,
    windowGapsOut = 12,
    singleWindowGapsOut = 12,

    -- Window styling
    opacitySingleMode = 0,
    singleWindowOpacity = 0.92,
    -- only works if opacitySingleMode is off (0)
    activeWindowOpacity = 0.92,
    inactiveWindowOpacity = 0.86,

    windowRounding = 12,
    windowRoundingPower = 5,
    windowBorderSize = 0,
    activeWindowBorderColour = "rgba(" .. col("primary", "f1be6d") .. "e6)",
    inactiveWindowBorderColour = "rgba(" .. col("onSurfaceVariant", "d2c4b4") .. "1A)",

    -- Animations
    -- "m3-expressive", "m3-hybrid", "m3-standard", "simple"
    animationProfile = "m3-hybrid",
    animationsEnabled = true,
    -- only used by the "simple" profile
    animationSpeed = 8,

    -- slide, slidevert, slidefade, slidefadevert
    workspaceStyle = "slidevert",
    -- dwindle, master, scrolling
    tilingLayout = "scrolling",

    -- General
    allowTearing = false,
    directScanout = false,

    -- Touchpad / gestures
    touchpadDisableTyping = true,
    touchpadScrollFactor = 0.3,
    workspaceSwipeFingers = 3,
    gestureFingers = 3,
    gestureFingersMore = 4,

    -- Misc
    volumeStep = 10,
    volumeMax = 100,
    sleepGestureCmd = "systemctl suspend-then-hibernate",
    specialWsCloseAny = true,

    ------------------
    ---- KEYBINDS ----
    ------------------

    -- Each entry is a keyspec string ("MOD + KEY" format) or an array of
    -- keyspecs, all bound to the same action.

    -- Apps
    kbTerminal = { "SUPER + T", "SUPER + Return" },
    kbBrowser = "SUPER + B",
    kbEditor = "SUPER + C",
    kbFileExplorer = "SUPER + E",
    kbAudioSettings = "CTRL + ALT + V",
    kbSmartFloat = "SUPER + ALT + Space",

    -- Window management
    kbCloseWindow = "SUPER + Q",
    kbWindowFullscreen = "SUPER + F",
    kbWindowMaximized = { "SUPER + ALT + F", "SUPER + SHIFT + F" },
    kbToggleColumnWidth = "SUPER + D",
    kbToggleSplit = "SUPER + R",
    kbToggleGroup = "SUPER + Comma",
    kbUngroup = "SUPER + U",
    kbGroupLockActive = "SUPER + SHIFT + Comma",

    kbWindowCycleNext = { "ALT + TAB", "SUPER + Tab" },
    kbWindowCyclePrev = { "SHIFT + ALT + TAB", "SUPER + SHIFT + Tab" },
    kbWindowGroupCycleNext = "CTRL + ALT + TAB",
    kbWindowGroupCyclePrev = "CTRL + SHIFT + ALT + TAB",
    kbGroupNext = "CTRL + SUPER + Tab",
    kbGroupPrev = "CTRL + SHIFT + SUPER + Tab",

    kbPinWindow = "SUPER + P",
    kbMoveWindow = "SUPER + Z",
    kbResizeWindow = "SUPER + ALT + X",
    kbCenterWindow = "CTRL + SUPER + Backslash",
    kbNormalizeWindow = "CTRL + SUPER + ALT + Backslash", -- 55x70 + center
    kbWindowPip = "SUPER + ALT + Backslash",

    kbWindowMoveLeft = { "SUPER + SHIFT + Left", "SUPER + SHIFT + H" },
    kbWindowMoveDown = { "SUPER + SHIFT + Down", "SUPER + SHIFT + J" },
    kbWindowMoveUp = { "SUPER + SHIFT + Up", "SUPER + SHIFT + K" },
    kbWindowMoveRight = { "SUPER + SHIFT + Right", "SUPER + SHIFT + L" },

    kbMouseMove = { "SUPER + mouse:272", "SUPER + SHIFT + mouse:272" },
    kbMouseResize = { "SUPER + mouse:273", "SUPER + SHIFT + mouse:273" },

    -- Focus
    -- No H/L aliases: SUPER+H opens the Hub and SUPER+L locks the session;
    -- duplicate keyspecs fire both binds.
    kbFocusLeft = { "SUPER + Left", "CTRL + SUPER + Left" },
    kbFocusDown = "SUPER + Down",
    kbFocusUp = "SUPER + Up",
    kbFocusRight = { "SUPER + Right", "CTRL + SUPER + Right" },
    kbFocusLastWindow = "SUPER + End",
    kbFocusFirstWindow = "SUPER + Home",

    -- Resize
    kbWindowIncreaseWidth = { "SUPER + Equal", "SUPER + ALT + Right" },
    kbWindowDecreaseWidth = { "SUPER + Minus", "SUPER + ALT + Left" },
    kbWindowIncreaseHeight = { "SUPER + SHIFT + Equal", "SUPER + ALT + Down" },
    kbWindowDecreaseHeight = { "SUPER + SHIFT + Minus", "SUPER + ALT + Up" },
    kbWindowExpandLeft = "SUPER + code:20",
    kbWindowShrinkLeft = "SUPER + code:21",
    kbWindowFillScreen = "SUPER + CTRL + F",

    -- Workspaces (User's workspace setup - DO NOT CHANGE!)
    kbGoToWs = "SUPER",
    kbGoToWsGroup = "CTRL + SUPER",
    kbMoveWinToWs = "SUPER + ALT",
    kbMoveWinToWsSilent = "SUPER + SHIFT",
    kbMoveWinToWsGroup = "CTRL + SUPER + ALT",

    -- Workspace navigation
    kbNextWs = { "SUPER + mouse_down", "CTRL + SUPER + Down", "SUPER + Page_Down" },
    kbPrevWs = { "SUPER + mouse_up", "CTRL + SUPER + Up", "SUPER + Page_Up" },
    kbNextWsGroup = "CTRL + SUPER + mouse_down",
    kbPrevWsGroup = "CTRL + SUPER + mouse_up",
    kbMoveWinToWsNext = { "SUPER + ALT + mouse_down", "SUPER + ALT + Page_Down", "CTRL + SUPER + SHIFT + Down" },
    kbMoveWinToWsPrev = { "SUPER + ALT + mouse_up", "SUPER + ALT + Page_Up", "CTRL + SUPER + SHIFT + Up" },
    kbCycleNextWs = "SUPER + ALT + bracketright",
    kbCyclePrevWs = "SUPER + ALT + bracketleft",
    kbToggleLastWorkspace = "SUPER + grave",

    -- Monitor focus/move
    kbFocusMonitorLeft = { "SUPER + CTRL + H", "SUPER + CTRL + left" },
    kbFocusMonitorDown = { "SUPER + CTRL + J", "SUPER + CTRL + down" },
    kbFocusMonitorUp = { "SUPER + CTRL + K", "SUPER + CTRL + up" },
    kbFocusMonitorRight = { "SUPER + CTRL + L", "SUPER + CTRL + right" },

    kbMoveMonitorLeft = { "SUPER + SHIFT + CTRL + H", "SUPER + SHIFT + CTRL + left" },
    kbMoveMonitorDown = { "SUPER + SHIFT + CTRL + J", "SUPER + SHIFT + CTRL + down" },
    kbMoveMonitorUp = { "SUPER + SHIFT + CTRL + K", "SUPER + SHIFT + CTRL + up" },
    kbMoveMonitorRight = { "SUPER + SHIFT + CTRL + L", "SUPER + SHIFT + CTRL + right" },

    -- Layout
    kbPreselectLeft = "SUPER + bracketleft",
    kbPreselectRight = "SUPER + bracketright",

    -- Special workspace toggles
    kbSystemMonitorWs = "CTRL + SHIFT + Escape",
    kbMusicWs = "SUPER + M",
    kbCommunicationWs = "SUPER + X",
    kbTodoWs = "SUPER + O",
    kbSpecialWs = "SUPER + S",

    -- Move the active window to/from special workspaces
    kbMoveWinToWsSpecial = "CTRL + SUPER + SHIFT + Up",
    kbMoveWinFromWsSpecial = "CTRL + SUPER + SHIFT + Down",
    kbMoveWinToSysmon = "SUPER + CTRL + SHIFT + Escape",
    kbMoveWinToMusic = "SUPER + CTRL + SHIFT + M",
    kbMoveWinToCommunication = "SUPER + CTRL + SHIFT + D",
    kbMoveWinToTodo = "SUPER + CTRL + SHIFT + T",

    -- Volume (wpctl) & Media
    kbVolumeMute = { "XF86AudioMute", "SUPER + SHIFT + M" },
    kbMicMute = "XF86AudioMicMute",
    kbVolumeUp = "XF86AudioRaiseVolume",
    kbVolumeDown = "XF86AudioLowerVolume",
    kbMediaToggle = { "CTRL + SUPER + Space", "XF86AudioPlay", "XF86AudioPause" },
    kbMediaNext = { "CTRL + SUPER + Equal", "XF86AudioNext" },
    kbMediaPrev = { "CTRL + SUPER + Minus", "XF86AudioPrev" },
    kbMediaStop = { "CTRL + SUPER + Backspace", "XF86AudioStop" },

    -- System
    kbSwitchKeyboardLayout = "SUPER + ALT + K",
    kbSuspend = "XF86Sleep",
    kbSleep = "SUPER + ALT + L",

    ----------------------------
    ---- MATUSHELL KEYBINDS ----
    ----------------------------

    -- Panels
    kbHub = "SUPER + H",
    kbNotifications = "SUPER + N",
    kbLock = "SUPER + L",
    kbPowerMenu = "CTRL + ALT + Delete",
    kbControlCenter = "SUPER + ALT + C",
    kbMediaPlayer = "SUPER + ALT + M",
    kbSystemMonitor = "SUPER + ALT + S",
    kbWallpaperCarousel = "SUPER + W",

    -- Launcher
    kbLauncher = "SUPER + space",

    -- Toggles
    kbToggleDnd = "SUPER + ALT + D",
    kbToggleGamemode = "SUPER + ALT + G",
    kbToggleKeepAwake = "SUPER + ALT + I",
    kbThemeToggle = "SUPER + ALT + T",

    -- Clipboard & emoji
    kbClipboard = "SUPER + V",
    kbEmojiPicker = { "SUPER + Period", "SUPER + semicolon" },

    -- Capture
    kbColorPicker = "SUPER + SHIFT + C",
    kbScreenshotRegion = { "SUPER + SHIFT + S", "SUPER + SHIFT + ALT + S" },
    kbScreenshotFullscreen = "Print",
    kbRecordFullscreen = { "SUPER + ALT + R", "CTRL + ALT + R" },

    -- Brightness / volume via the shell OSD
    kbBrightnessUp = { "XF86MonBrightnessUp", "CTRL + ALT + Right" },
    kbBrightnessDown = { "XF86MonBrightnessDown", "CTRL + ALT + Left" },
    kbShellVolumeUp = "CTRL + ALT + Up",
    kbShellVolumeDown = "CTRL + ALT + Down",
}
