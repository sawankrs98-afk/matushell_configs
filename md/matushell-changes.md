# Matushell Customizations & Pipeline Fixes

This document records all changes made to **Matushell**, **Hyprland**, the **Matugen Theming Pipelines**, and **Neovim Themes**.

---

## 1. Hyprland Keybindings & Shortcuts

- **Wallpaper Carousel (`SUPER + W`)**:
  - Bound `SUPER + W` directly to `matushell:wallpaperCarousel`.
  - Pressing `SUPER + W` now invokes the center-snapping M3 wallpaper carousel drawer.
  - Bound `SUPER + SHIFT + W` to `matushell:wallpaperPicker` (Hub settings grid).
  - Files modified:
    - `~/.config/hypr/shell/matus.lua`
    - `~/.config/quickshell/matushell/dots/hypr/shell/matus.lua`
- **Hyprland Window Group Toggle (`SUPER + G`)**:
  - Moved `hl.dsp.group.toggle()` from `SUPER + W` to `SUPER + G` (the standard Hyprland group toggle key) to eliminate keybinding collision with the wallpaper carousel.
  - Files modified:
    - `~/.config/hypr/hyprland/keybinds.lua`
    - `~/.config/quickshell/matushell/dots/hypr/hyprland/keybinds.lua`
- **Neovim Direct Launch (`SUPER + SHIFT + N`)**:
  - Added keybind `SUPER + SHIFT + N` to launch Neovim directly in terminal (`vars.terminal .. " -e nvim"`).
  - Files modified:
    - `~/.config/hypr/hyprland/keybinds.lua`
    - `~/.config/quickshell/matushell/dots/hypr/hyprland/keybinds.lua`

---

## 2. Wallpaper Sorting (Most Recent Downloads First, Matching iNiR)

- Previously, `FolderListModel` had no `sortField` specified, defaulting to alphabetical order (`FolderListModel.Name`).
- Configured:
  ```qml
  sortField: FolderListModel.Time
  sortReversed: false
  ```
- Wallpapers in both the Wallpaper Carousel and the Settings Hub Wallpaper Picker are now ordered by file modification time (most recent downloads first).
- Files modified:
  - `quickshell/Modules/Drawers/Launcher/Views/WallpaperView.qml`
  - `quickshell/Modules/Hub/Pages/Style/Subpages/WallpaperPicker.qml`

---

## 3. Light Mode & Matugen Theming Pipelines

No color generation logic or formulas were altered. The external pipeline hooks were wired up and fixed so all consumers receive generated colors smoothly in both Light and Dark modes:

1. **Hyprland Color Scheme Reload**:
   - Added `post_hook = 'hyprctl reload'` to `[templates.hyprland-scheme]` in `~/.config/matugen/config.toml`.
   - Hyprland now automatically refreshes window borders, shadows, and groupbars whenever a new color scheme is generated.
2. **KDE / Dolphin / QtEngine Integration**:
   - Added `post_hook = 'bash ~/.config/matugen/scripts/apply-kde.sh &'` to `[templates.qtengine-colors]` in `~/.config/matugen/config.toml`.
   - `apply-kde.sh` syncs Matugen colors to `~/.config/kdeglobals` and `~/.local/share/color-schemes/Matushell.colors`, allowing Dolphin and Qt applications to update.
3. **GTK 3 & GTK 4 Settings Synchronization**:
   - In `~/.config/matugen/scripts/apply-gtk.sh`, added updating of `~/.config/gtk-3.0/settings.ini` and `~/.config/gtk-4.0/settings.ini` (`gtk-application-prefer-dark-theme`, `gtk-theme-name`, `gtk-icon-theme-name`).
   - GTK applications that read `settings.ini` now switch between `adw-gtk3` (light) and `adw-gtk3-dark` (dark) alongside the `gsettings` desktop portal.
4. **Theme Mode Selection in Settings Hub**:
   - In `quickshell/Core/Theming.qml`, updated `setThemeMode(mode)` guard condition to:
     ```qml
     if (MatusConfig.wallpaper.colorScheme === mode && currentTheme === mode && overrideMode.length === 0)
         return;
     ```
   - Clicking Light/Dark in Settings Hub now recolors and updates even if a temporary override was active.

---

## 4. Cursor & Performance Defaults

- **Material White Cursor**:
  - Set `material_light_cursors` (size 28) across Hyprland (`variables.lua`), GTK 3/4 (`settings.ini`), Xresources, and system defaults.
- **Resource-Optimized Blur**:
  - Tuned blur settings in `~/.config/hypr/variables.lua` (`blurPasses = 2`, `blurSize = 6`, `blurPopups = false`, `blurInputMethods = false`, `new_optimizations = true`) to minimize GPU resource consumption while retaining blur quality.

---

## 5. App Launcher (App Picker) Light Mode Contrast Fix

- **Root Cause**:
  - `Theming.bezelActive` unconditionally forced `connectedSurface` to `#000000` (pure black) whenever `bezelMode` was enabled on connected docks/bars.
  - In light mode, typography tokens (`Theming.surfaceOn`, subtitles, key hints) flipped to dark charcoal/black (`#1c1c14`), rendering dark text against a pure black drawer background and making all text illegible.
- **Fixes Applied**:
  1. In `quickshell/Core/Theming.qml`:
     - Gated `bezelActive` to dark mode:
       ```qml
       readonly property bool bezelActive: MatusConfig.appearance.bezelMode && currentTheme === "dark" && (MatusConfig.bar.mode === "connected" || (MatusConfig.bar.mode === "island" && MatusConfig.bar.islandStyle === "notch") || MatusConfig.dock.mode === "connected")
       ```
     - In light mode, connected chrome now correctly falls back to `surface` (`#fdf9ec`), giving the launcher a clean light canvas.
  2. In `quickshell/Modules/Drawers/Launcher/Views/AppView.qml`:
     - Result row selection highlight now uses `0.16` opacity in light mode for visible row selection.
     - Active entry text colors bind to `Theming.surfaceOn` and `Theming.opacitySecondary` in light mode to guarantee maximum contrast and readability.
  3. In `quickshell/Modules/Drawers/Launcher/LauncherContent.qml`:
     - Added a subtle `outlineVariant` border to the search input field for sharp visual definition on light backgrounds.

---

## 6. Terminal Colors & Harmonization Calibration

- **Root Cause**:
  1. `DEFAULT_PALETTE["light"]` in `~/.config/matugen/scripts/harmonizer.py` contained low-contrast dark-mode pastels, and Blue (`term4` and `term12`) was erroneously mapped to yellow `#FFD866`.
  2. The harmonization `--strength 0.95` flag in `config.toml` rotated all 16 ANSI color hues 95% into the wallpaper's primary hue. This collapsed syntax highlighting into a monochrome wash where red, blue, green, and cyan all became the exact same olive/yellow-green hue.
- **Fixes Applied**:
  1. Updated `DEFAULT_PALETTE["light"]` in `harmonizer.py` with calibrated, rich, WCAG-accessible Material 3 tones (tones 35–45) with authentic color identities:
     - `term1` (Red): `#BA1A1A`
     - `term2` (Green): `#2E6B27`
     - `term3` (Amber/Yellow): `#8C5E00`
     - `term4` (Blue): `#1B60B2` (correct blue hue)
     - `term5` (Magenta): `#8A2BE2`
     - `term6` (Cyan): `#006A6A`
     - `term8` (Muted/Comments): `#797869`
  2. Adjusted harmonization strength from `0.95` to `0.25` in:
     - `~/.config/matugen/scripts/harmonizer.py`
     - `~/.config/matugen/scripts/generate-term-colors.py`
     - `~/.config/matugen/config.toml`
     - `~/.config/quickshell/matushell/dots/matugen/config.toml`
  3. Regenerated terminal colors (`~/.config/kitty/matugen.conf`), producing clear, distinguishable, high-contrast syntax highlighting in both Light and Dark modes.

---

## 7. Neovim Light Themes

Added 13 top-tier, curated light themes into `~/.config/nvim/lua/plugins/themes.lua` without removing any of the existing 40 dark themes (total: 53 themes):

1. **Catppuccin Latte** (`catppuccin-latte`) — Soothing warm cream pastel
2. **Tokyo Night Day** (`tokyonight-day`) — Modern vibrant azure & crimson
3. **Rosé Pine Dawn** (`rose-pine-dawn`) — SoHo aesthetic dawn (rose & pine)
4. **Kanagawa Lotus** (`kanagawa-lotus`) — Japanese ink paper & lotus embers
5. **Dayfox** (`dayfox`) — Sunlit clean minimal (navy & coral)
6. **Dawnfox** (`dawnfox`) — Warm rose dawn (muted pastel accents)
7. **GitHub Light Default** (`github_light_default`) — Crisp high-contrast workspace
8. **Solarized Osaka Light** (`solarized-osaka-light`) — Electric cyan & amber canvas
9. **Cyberdream Light** (`cyberdream-light`) — Clean cyber futuristic (royal blue)
10. **Ayu Light** (`ayu-light`) — Golden sun paper (tangerine & ocean)
11. **Monokai Pro Light** (`monokai-pro-light`) — Vibrant spectrum light canvas
12. **Bamboo Light** (`bamboo-light`) — Organic natural jade & coral
13. **OneNord Light** (`onenord-light`) — Clean arctic glacier (nordic blues)

All themes are accessible via `:ThemeSelect` (or `<leader>th`), `:CurrentTheme` (or `<leader>tc`), or `:colorscheme <name>`.
