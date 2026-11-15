local vars  = require("variables")

-- Sanitized inputs
local theme = string.gsub(tostring(vars.cursorTheme or "Adwaita"), "['\"\n\r%s]", "")
local size  = tonumber(vars.cursorSize) or 24

-- Helper for direct file writing (avoids spawning unnecessary subshells)
local function write_file(filepath, content)
    local dir = filepath:match("(.+)/")
    if dir then
        os.execute("mkdir -p " .. string.format("%q", dir))
    end
    local file, err = io.open(filepath, "w")
    if file then
        file:write(content)
        file:close()
    else
        io.stderr:write("Failed to write to " .. filepath .. ": " .. tostring(err) .. "\n")
    end
end

-- Cursors
local function apply_cursors()
    local home = os.getenv("HOME")

    -- Write Xresources
    write_file(home .. "/.Xresources", string.format("Xcursor.theme: %s\nXcursor.size: %d\n", theme, size))
    os.execute("xrdb -merge ~/.Xresources 2>/dev/null")

    -- Write GTK-3.0 and GTK-4.0 settings cleanly
    local gtk_content = string.format("[Settings]\ngtk-cursor-theme-name=%s\ngtk-cursor-theme-size=%d\n", theme, size)
    write_file(home .. "/.config/gtk-3.0/settings.ini", gtk_content)
    write_file(home .. "/.config/gtk-4.0/settings.ini", gtk_content)

    -- Write default index.theme (for fallback compatibility)
    local index_content =
        string.format("[Icon Theme]\nName=Default\nComment=Default Cursor Theme\nInherits=%s\n", theme)
    write_file(home .. "/.local/share/icons/default/index.theme", index_content)

    -- Apply settings live to Hyprland, GNOME/GTK, and Environment
    hl.exec_cmd(string.format("hyprctl setcursor %s %d", theme, size))
    hl.exec_cmd(string.format("gsettings set org.gnome.desktop.interface cursor-theme %q", theme))
    hl.exec_cmd(string.format("gsettings set org.gnome.desktop.interface cursor-size %d", size))
end

apply_cursors()

-- Forward terminal preference to XFCE helpers.rc (exo-open / Thunar "Open Terminal Here")
hl.exec_cmd("mkdir -p ~/.config/xfce4 && echo 'TerminalEmulator=" .. (vars.terminal or "kitty") .. "' > ~/.config/xfce4/helpers.rc")

hl.on("hyprland.start", function()
    -- D-Bus and systemd integration
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")

    -- Keyring and auth
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto-delete trash older than 30 days
    hl.exec_cmd("trash-empty 30")

    -- Forward bluetooth media commands to MPRIS
    hl.exec_cmd("mpris-proxy")

    -- Start matushell
    hl.exec_cmd("matus run -d")
end)
