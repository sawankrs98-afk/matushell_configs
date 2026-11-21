# 🚀 Neovim Extras & Complete Configuration Guide

This document provides a comprehensive reference for all custom features, themes, typography controls, competitive programming workflows, LeetCode integrations, multi-language LSP engines, and bug fixes configured in this Neovim environment.

---

## 📑 Table of Contents
1. [Overview & Architecture](#1-overview--architecture)
2. [Themes Suite (40 Curated Dark Themes)](#2-themes-suite-40-curated-dark-themes)
3. [Typography & Font Customizer](#3-typography--font-customizer)
4. [Indentation Guide Lines & Active Scope](#4-indentation-guide-lines--active-scope)
5. [LeetCode Integration & Split-Window Bug Fix](#5-leetcode-integration--split-window-bug-fix)
6. [Niri Window Focus & Cursor Visibility Fix](#6-niri-window-focus--cursor-visibility-fix)
7. [Multi-Language LSP & Syntax Diagnostics Engine](#7-multi-language-lsp--syntax-diagnostics-engine)
8. [Unified Language Picker & Dynamic Manager](#8-unified-language-picker--dynamic-manager)
9. [Competitive Programming Fast I/O Templates](#9-competitive-programming-fast-io-templates)
10. [Neo-tree & Project File Navigation Suite](#10-neo-tree--project-file-navigation-suite)
11. [Master Keymaps Cheat Sheet](#11-master-keymaps-cheat-sheet)

---

## 1. Overview & Architecture

The configuration is modularized cleanly under [`~/.config/nvim/`](file:///home/saksham/.config/nvim/):

| Path | Purpose |
| :--- | :--- |
| [`init.lua`](file:///home/saksham/.config/nvim/init.lua) | Modular entrypoint: orchestrates UI, Editor, LSP, Languages, LeetCode, and CP. |
| [`lua/config/keybinds.lua`](file:///home/saksham/.config/nvim/lua/config/keybinds.lua) | ⭐ **Central Keybinds Variables File**: Edit any keybind here or run `:Keybinds`! |
| [`lua/core/options.lua`](file:///home/saksham/.config/nvim/lua/core/options.lua) | Editor settings, Zed-style gutter, cursor animations, spacing, and system clipboard. |
| [`lua/core/keymaps.lua`](file:///home/saksham/.config/nvim/lua/core/keymaps.lua) | Centralized keybindings connecting `config.keybinds` across all modes. |
| [`lua/modules/leetcode/`](file:///home/saksham/.config/nvim/lua/modules/leetcode/) | **Everything LeetCode**: Plugin options, daily pickers, topic tags, and `<leader>l*` keybinds. |
| [`lua/modules/competitive/`](file:///home/saksham/.config/nvim/lua/modules/competitive/) | **Everything Codeforces / CP**: CPH helper, language picker, results buffer, and `<leader>c*` keybinds. |
| [`lua/modules/languages/`](file:///home/saksham/.config/nvim/lua/modules/languages/) | **Language Toolchains**: C++ (`makeprg`, header switch), Rust (cargo), Python, Java & Java Swing (`<leader>js`/`<leader>jS`/`<leader>jw`), Zig. |
| [`lua/modules/ui/`](file:///home/saksham/.config/nvim/lua/modules/ui/) | **UI & Aesthetics**: 53 themes, 30 fonts, profiles, bufferline tabs, lualine, hairline indent guides, zen mode. |
| [`lua/modules/editor/`](file:///home/saksham/.config/nvim/lua/modules/editor/) | **Editor & Tools**: Neo-tree file explorer, smart folder nav, Telescope, ToggleTerm, WhichKey, GitSigns, Oil, Copilot, DAP. |
| [`lua/modules/lsp/`](file:///home/saksham/.config/nvim/lua/modules/lsp/) | **LSP & Completion**: JDTLS, Clangd, Rust-Analyzer, Pyright, Blink.cmp, LuaSnip, Conform formatters. |
| [`lua/plugins/`](file:///home/saksham/.config/nvim/lua/plugins/) | 100% backward-compatible forwarders ensuring legacy `require("plugins.xxx")` calls never break. |
| [`~/cp/templates/`](file:///home/saksham/cp/templates/) | Fast I/O competitive programming templates (C++, Python, Java, Rust, C). |

---

## 2. Themes Suite (40 Curated Dark Themes)

The theme engine is housed in [`lua/plugins/themes.lua`](file:///home/saksham/.config/nvim/lua/plugins/themes.lua). Every theme is hand-picked for high-contrast, multi-colored dark syntax highlighting with distinctive token colors (keywords, functions, types, strings, numbers, and operators all have vivid separate hues; washed-out mono-hues are avoided).

### 🎨 Theme Gallery by Category

#### ✦ Cyberpunk, Synthwave & Neon Glow
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Fluoromachine** | `fluoromachine` | Neon synthwave aesthetic, vibrant magenta glow, electric blues and cyans. |
| **Eldritch** | `eldritch` | Occult cyberpunk dark slate, radioactive lime, hot pink, vivid orange. |
| **Cyberdream** | `cyberdream` | True-black abyss background, high-contrast neon cyan, electric magenta, lime green. |
| **Solarized Osaka Vivid** | `solarized-osaka-vivid` | Electric cyan deep abyss, hyper-saturated warm accents and teal highlights. |
| **Embark** | `embark` | Cosmic midnight blue, seafoam green, radiant hot pink, sun-gold keywords. |
| **Carbonfox** | `carbonfox` | Pitch black carbon, stark electric cyan, emerald green, and sharp white tokens. |

#### ✦ Legendary High-Saturation Monokai & Atom
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Monokai Pro Classic** | `monokai-pro-classic` | The original iconic Monokai spectrum: hot pink, vibrant yellow, lime green, sky blue. |
| **Monokai Pro Spectrum** | `monokai-pro-spectrum` | Maximum contrast multi-colored spectrum with punchy saturated syntax tags. |
| **Monokai Pro Machine** | `monokai-pro-machine` | Fluorescent steel-cyan and cool teal infused Monokai palette. |
| **Monokai Pro Octagon** | `monokai-pro-octagon` | Deep navy background with vibrant polygonal spectrum accents. |
| **Monokai Pro Ristretto** | `monokai-pro-ristretto` | Warm roasted espresso base paired with vivid candy-colored syntax elements. |
| **Monokai Pro Standard** | `monokai-pro` | Balanced official Monokai Pro palette with ultra-crisp token separation. |
| **Dracula Official** | `dracula` | Classic gothic vampire slate purple: iconic cyan, green, orange, pink, and purple. |
| **One Dark Pro** | `onedark` | Atom's beloved dark syntax: balanced coral, chalky blue, green, and gold. |
| **Doom One** | `doom-one` | Doom Emacs flagship palette: rich charcoal with multi-colored jewel-tone syntax. |

#### ✦ Tokyo Night & Celestial Indigo
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Tokyo Night** | `tokyonight-night` | Midnight deep indigo, brilliant neon cyan, electric purple, and golden yellow. |
| **Tokyo Night Storm** | `tokyonight-storm` | Slate blue dark variant with luminous pastel-neon accents. |
| **Tokyo Night Moon** | `tokyonight-moon` | Rich twilight navy with balanced high-visibility syntax highlights. |

#### ✦ Catppuccin Pastel Rainbow
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Catppuccin Mocha** | `catppuccin-mocha` | Rich espresso dark base with the complete pastel rainbow (peach, green, mauve, sapphire). |
| **Catppuccin Macchiato** | `catppuccin-macchiato` | Dark cocoa background with vivid, punchy pastel accents. |
| **Catppuccin Frappé** | `catppuccin-frappe` | Graphite slate base with gentle yet high-contrast rainbow syntax. |

#### ✦ Vivid Ayu, Bamboo & Retro Groove
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Ayu Dark** | `ayu-dark` | Pitch dark canvas, fiery burnt orange keywords, electric golden yellows, and cyan types. |
| **Ayu Mirage** | `ayu-mirage` | Twilight slate blue-gray base with vivid tangerine, sea green, and sky blue. |
| **Sonokai Andromeda** | `sonokai` | Cosmic deep-purple Monokai evolution with saturated neon highlights. |
| **Bamboo Multiplex** | `bamboo-multiplex` | Deep lush jade background with vivid coral, lime, and warm gold tokens. |
| **Everforest** | `everforest` | Deep organic forest background (hard contrast mode) with autumn ember accents. |
| **Gruvbox Retro** | `gruvbox` | Legendary warm retro dark groove: high-contrast reddish-orange, aqua, yellow, and green. |
| **Gruvbox Material** | `gruvbox-material` | Material design rendition of Gruvbox with hard dark background and vivid tokens. |

#### ✦ Japanese Ink, Rosé Pine & Dusk Foxes
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Kanagawa Wave** | `kanagawa-wave` | Japanese ink wash painting tones: midnight water, autumn leaf embers, and spring buds. |
| **Kanagawa Dragon** | `kanagawa-dragon` | Samurai armor dark charcoal with saturated earthy ochres, greens, and cinnabar reds. |
| **Rosé Pine Moon** | `rose-pine-moon` | Soho dusk aesthetic: dark slate, pine needle teal, blush rose, and warm gold. |
| **Nightfox** | `nightfox` | Deep twilight navy with rich multi-colored syntax balance. |
| **Nordfox** | `nordfox` | Arctic icy cobalt base with warm golden highlights and glacier blues. |
| **Duskfox** | `duskfox` | Deep plum-purple base with soft rose, magenta, and amber tokens. |
| **Terafox** | `terafox` | Deep emerald/teal dark base with bright copper, aqua, and mint highlights. |

#### ✦ Material Candy, High Contrast & Arctic Fusion
| Theme Name | Colorscheme ID | Palette Highlights & Characteristics |
| :--- | :--- | :--- |
| **Material Oceanic** | `material-oceanic` | Abyssal ocean navy with candy-bright seafoam, cyan, coral, and violet syntax. |
| **Material Palenight** | `material-palenight` | Deep violet-slate canvas with crisp lavender, mint green, and pale yellow tokens. |
| **Material Deep Ocean** | `material-deep-ocean` | Pitch midnight abyss with electric sapphire and neon turquoise highlights. |
| **GitHub Dark High Contrast** | `github_dark_high_contrast` | Pure obsidian background with high-contrast amber, sky blue, and emerald accents. |
| **OneNord Arctic** | `onenord` | Hybrid combining One Dark's vivid multi-color tokenization with Nord's icy glacier palette. |

### 🛠️ Theme Features & Bespoke Visual Personality Engine
Every theme in Neovim now has its own **handcrafted visual personality** instead of sharing generic gray gutters or static blue cursors:
- **Glowing Active Line Number (`CursorLineNr`)**: The active line number radiates with each theme's signature vibrant accent (e.g. glowing warm amber `#FABD2F` in Gruvbox, iconic vampire yellow `#F1FA8C` in Dracula, electric peach `#FF9E64` in Tokyo Night, samurai gold `#E6C384` in Kanagawa, and neon cyan `#00F0FF` in Fluoromachine).
- **Dynamic Terminal Cursor Sync (OSC 12)**: Your hardware terminal cursor (Kitty) and Neovim editor cursor automatically adopt the theme's bespoke hue in real-time (Dracula Pink, Gruvbox Orange, Tokyo Blue, Catppuccin Lavender, Cyberdream Neon Lime, etc.).
- **Palette-Framed Windows & Popups (`FloatBorder`, `TelescopeBorder`, `CmpBorder`)**: Floating documentation, autocomplete menus, and Telescope windows are framed in each theme's distinct accent color.
- **Themed Indentation Scope (`IblScope`)**: The active indentation guide hairline dynamically lights up in the theme's signature color as you traverse code blocks.
- **Themed Tab Bar (`Bufferline`)**: Active tab indicators, close icons, and modified indicators harmonize with the active theme.
- **Dedicated Statusline (`Lualine`) Mapping**: Every theme maps to its native or custom-tuned statusline palette.
- **`<leader>th`** or **`:ThemeSelect`**: Opens the Telescope Theme Switcher with instant live preview as you browse with `j`/`k`. Pressing `<Esc>` cancels and restores; `<CR>` saves and persists.
- **`<leader>tc`** or **`:CurrentTheme`**: Displays a detailed HUD popup showing active theme, signature accent colors, cursor tone, active line glow, and persistence state.
- **`:ToggleVSCodeComments`**: Toggles between theme-native comment coloring and VS Code signature green comments (`#6A9955`).
- **Dynamic Terminal Window Background (OSC 11)**: Synchronizes the terminal emulator's frame background with Neovim in real time.
- **Persistence**: Remembers your chosen theme across restarts via `~/.local/share/nvim/current_theme.txt`.

---

## 3. Typography & Font Customizer

Configured in [`lua/plugins/fonts.lua`](file:///home/saksham/.config/nvim/lua/plugins/fonts.lua). This system gives you full GUI and terminal-level typography management with a default size of **13.0 pt**.

### 🔤 Curated Top 30 Best Developer Fonts (Modern, Sleek, Highly Legible Monospaces)
1. **JetBrains Mono Nerd Font** *(Default)* — *Philipp Nurullin (JetBrains)*: **Best for: Daily all-around coding & marathon sessions**. Industry gold standard, tall x-height, distinct `0`/`O` & `1`/`l`.
2. **SF Mono (Apple San Francisco)** — *Apple*: **Best for: macOS & Xcode elegance and clean minimalist setups**. Pristine Cupertino geometry with balanced tracking.
3. **Fira Code Nerd Font** — *Nikita Prokopov*: **Best for: Ligature-heavy programming (Rust, TS, Elixir, Haskell)**. Iconic programming ligatures (`->`, `=>`, `!=`, `===`).
4. **Cascadia Code (CaskaydiaCove NF)** — *Aaron Bell (Microsoft)*: **Best for: Flowing cursive italic comments & modern Windows/VS Code aesthetic**. Crisp geometry with thick legible strokes.
5. **Geist Mono Nerd Font** — *Vercel*: **Best for: Modern web stacks, Next.js & sleek modern UI code**. Swiss minimalist precision with razor-sharp geometric cuts.
6. **IBM Plex Mono (BlexMono NF)** — *Mike Abbink (IBM)*: **Best for: Systems engineering & backend (Go, C, Java)**. Sharp industrial rhythm and punchy punctuation.
7. **Maple Mono NF** — *subframe7536*: **Best for: Modern aesthetic typography, soft rounded terminals, and gorgeous coding ligatures**. One of the most popular modern coding fonts.
8. **Intel One Mono (IntoneMono NF)** — *Intel & Frere-Jones*: **Best for: Zero eye-strain & long marathon sessions**. Scientifically optimized character disambiguation.
9. **Iosevka Nerd Font** — *Belleve Invis*: **Best for: Multi-pane vertical splits & small laptop displays**. Ultra-compact condensed architecture (effortlessly fits 3+ panes).
10. **Iosevka Term Nerd Font** — *Belleve Invis*: **Best for: Strict column alignment, zero ligature distraction, and maximum vertical code density**.
11. **Zed Mono Nerd Font** — *Zed Industries*: **Best for: Ultra-fast visual parsing & high-DPI screens**. Custom-designed natively for the high-performance Zed code editor.
12. **Commit Mono Nerd Font** — *Bogdan Docev*: **Best for: Pure flow state without visual gimmicks**. Optically neutral developer ergonomics designed to disappear while coding.
13. **Monaspace Neon (GitHub)** — *GitHub Next*: **Best for: Modern GitHub aesthetics, texture-healing spacing & cutting-edge coding ligatures**.
14. **Monaspace Argon (GitHub)** — *GitHub Next*: **Best for: Warm, friendly, highly legible modern coding with gentle curved strokes**. Humanist grotesque variant.
15. **Monaspace Krypton (GitHub)** — *GitHub Next*: **Best for: Sci-fi terminal vibe, crisp square geometry, and sharp technical density**. Futuristic mechanical variant.
16. **Monaspace Xenon (GitHub)** — *GitHub Next*: **Best for: Punchy code density and crisp, distinctive character geometry with great presence**. Deep chiseled slab variant.
17. **Hack Nerd Font** — *Christopher Simpkins*: **Best for: Deep Linux terminal work & hardcore CLI tools**. Open-source workhorse with wide apertures and zero ambiguity.
18. **Source Code Pro (SauceCodePro NF)** — *Paul D. Hunt (Adobe)*: **Best for: Distinct, high-contrast coding symbols**. Large punchy brackets, braces, quotes and semicolons.
19. **Hasklig (Hasklug NF)** — *Ian Tuomi*: **Best for: Functional programming (Haskell, Scala, OCaml, Rust)**. Source Code Pro supercharged with multi-character ligatures.
20. **Meslo LG M Nerd Font** — *André Berg*: **Best for: Classic macOS Terminal & Powerlevel10k look with perfectly balanced medium line height**.
21. **Meslo LG S Nerd Font** — *André Berg*: **Best for: High-density viewing with classic Apple Menlo glyph forms and tight vertical spacing**.
22. **0xProto Nerd Font** — *0xType*: **Best for: Low-level systems, Assembly & C**. High-contrast character separation for dense algorithm blocks.
23. **Lilex Nerd Font** — *Maxim V*: **Best for: Contemporary web development & clean ligatures**. Warm curved stems and crisp symbols.
24. **Google Sans Code Nerd Font** — *Google*: **Best for: Modern Google aesthetics & soft typography**. High eye-fatigue relief and smooth curves.
25. **Roboto Mono Nerd Font** — *Christian Robertson (Google)*: **Best for: Wide screens & expansive airy reading**. Broad geometric curves and wide open counters.
26. **Ubuntu Mono Nerd Font** — *Dalton Maag (Canonical)*: **Best for: Warm friendly personality & eye-strain reduction**. Distinctive rounded terminals and cheerful readability.
27. **Inconsolata Nerd Font** — *Raph Levien*: **Best for: Python, data science & classic humanist rhythm**. Consolas-inspired stroke balance with timeless elegance.
28. **Victor Mono Nerd Font** — *Mark Geyzer*: **Best for: Luxury styling & expressive comments**. Slender monospace body paired with authentic cursive script.
29. **D2Coding Ligature (D2Koding NF)** — *Naver*: **Best for: Pinpoint sharp character shapes, clear punctuation distinctions, and code ligatures**.
30. **DejaVu Sans Mono Nerd Font** — *DejaVu Team*: **Best for: Rock-solid stability, maximum character coverage, and time-tested monospace clarity**.

### ⚙️ Interactive Typography Controls
- **`<leader>fc`** or **`:FontCustomize`**: Opens the interactive Font Control Panel dropdown:
  - **Font Size**: Tune size from 8.0pt to 32.0pt with 0.5pt increments.
  - **Line Height / Cell Height**: Adjust vertical line height from 80% to 140% in 5% steps.
  - **Cell Width**: Adjust horizontal character spacing from 85% to 120%.
  - **Font Weight**: Switch between Light, Regular, Medium, SemiBold, and Bold weights.
  - **Programming Ligatures**:
    - *Enabled Everywhere*: Full ligatures rendered across all code.
    - *Disabled on Cursor Line*: Automatically expands ligatures into raw ASCII characters on the active line so editing arrows/operators is effortless.
    - *Disabled Completely*: Pure ASCII representation everywhere.
  - **Linespace Padding**: Adjust internal editor pixel padding from 0px to 6px.
  - **Reset to Defaults**: One-click restore to recommended font specifications.
- **`<leader>fp`** or **`:FontSelect`**: Opens the 30-font switcher with live preview while navigating.
- **`<leader>fi`** or **`:CurrentFont`**: Displays the active font information card.
- **`<leader>f+`** / **`<leader>f-`**: Quickly bump font size up or down by 0.5pt.
- **Persistence & Terminal Sync**: Settings persist in `~/.local/share/nvim/font_settings.json` and automatically update `~/.config/kitty/font.conf` (which is included in `kitty.conf` and live-reloads Kitty instantaneously via watcher, sockets, and SIGUSR1).

---

## 4. Indentation Guide Lines & Active Scope

Engineered in [`lua/plugins/indent.lua`](file:///home/saksham/.config/nvim/lua/plugins/indent.lua) using `indent-blankline.nvim` (ibl):

- **Hairline Aesthetic**: Uses the crisp single box-drawing light vertical character (`│`), strictly enforcing non-bold rendering (`bold = false`, `nocombine = true`) to prevent bulky or thick bars.
- **Calibrated Opacity**: Employs mathematical RGB alpha blending calculated dynamically against the active theme's background and foreground:
  - **Base Guides**: 22% alpha opacity (`#3b3a3c`) — subtle and non-intrusive.
  - **Active Scope**: 50% alpha opacity (`#6a676b`) — clearly highlights the current code block / function scope.
- **Presets & Cycling**:
  - *Subtle*: 14% base / 35% scope (ultra-faint hairline).
  - *Medium* *(Default)*: 22% base / 50% scope (calibrated optimal contrast).
  - *High*: 30% base / 68% scope (high-visibility guides).
- **Keybindings**:
  - **`<leader>ti`** or **`<leader>ug`** or **`:ToggleIndentGuides`**: Toggle indentation guides on/off.
  - **`<leader>to`** or **`:CycleIndentOpacity`**: Cycle guide opacity between Subtle ➔ Medium ➔ High.

---

## 5. LeetCode Integration & Split-Window Bug Fix

Configured in [`lua/plugins/leetcode.lua`](file:///home/saksham/.config/nvim/lua/plugins/leetcode.lua).

### 🖥️ Interface Layout
- **Split Layout**: Problem statement on the left (42% width), code editor on the right (matching the official LeetCode web UI).
- **Full-Width Bottom Console**: Pops up automatically on running test cases with vertical testcase and result view.
- **Pre-Authenticated**: Pre-configured session credentials for instant access without manual browser cookie hunting.
- **Syntax Injection**: Automatically injects `struct Solution;` for Rust and `from typing import *` for Python, ensuring standalone LeetCode code passes strict LSP syntax checks.

### 🐛 The Horizontal Split / Duplicate Pane Bug & Resolution
- **Issue**: Previously, running commands or opening problems would intermittently cause the code buffer to duplicate into top and bottom horizontal splits, requiring manual `:q` commands to restore order.
- **Root Cause**: The default `leetcode.nvim` UI locked the code editor window with `winfixbuf = true`. When Neovim attempted to display another file or buffer in that window, `winfixbuf` rejected the buffer swap, forcing Neovim to open an unwanted horizontal split to display the buffer.
- **Resolution**:
  1. Removed `winfixbuf` from code editor window initialization.
  2. Implemented an automated guard hook across `BufEnter`, `FileType`, and `BufWinEnter`:
     ```lua
     if vim.bo[args.buf].buftype == "" and vim.bo[args.buf].filetype ~= "leetcode.nvim" then
         vim.opt_local.winfixbuf = false
     end
     ```
  3. All code windows now remain completely free to switch buffers without ever splitting involuntarily.

### ⚡ LeetCode Keybindings (`<leader>l...`)
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>ld` | `:Leet daily` | Open the Daily Challenge problem picker. |
| `<leader>lq` | Direct Daily | Instantly open today's Daily Question directly. |
| `<leader>le` | `:Leet easy` | Filter and browse Easy problems via Telescope. |
| `<leader>lm` | `:Leet medium` | Filter and browse Medium problems via Telescope. |
| `<leader>lh` | `:Leet hard` | Filter and browse Hard problems via Telescope. |
| `<leader>lu` | `:Leet unsolved` | Filter and browse Unsolved (Todo) problems. |
| `<leader>lS` | `:Leet solved` | Filter and browse Solved (AC) problems. |
| `<leader>lT` | `:Leet topics` | Browse problems categorized by algorithms/data-structure tags. |
| `<leader>lR` | `:Leet random` | Select and open a random problem. |
| `<leader>lr` | `:Leet reset` | **Reset solution code back to starter template** (LeetCode & CP). |
| `<leader>lx` | `:Leet reset` | Reset solution code back to starter template (alias). |
| `<leader>lt` | `:Leet run` | Run default test cases against your code. |
| `<leader>lT` | `:Leet test` | Run custom user-defined test cases. |
| `<leader>ls` | `:Leet submit` | Submit your solution to LeetCode judges. |
| `<leader>lc` | `:Leet console` | Toggle the test results and execution console. |
| `<leader>li` | `:Leet info` | Toggle problem statistics and info sidebar. |
| `<leader>lD` | `:Leet desc` | Toggle problem description split on the left. |
| `<leader>lH` | `:Leet hints` | View official hints for the active problem. |
| `<leader>lo` | `:Leet open` | Open the active problem in your web browser. |
| `<leader>ly` | `:Leet yank` | Copy solution code directly to system clipboard. |
| `<leader>lX` | `:Leet reset` | Reset problem buffer back to LeetCode starter template. |
| `<leader>lP` | `:Leet last_submit` | Inspect your last accepted submission. |
| `<leader>lM` | `:Leet menu` | Open the LeetCode dashboard menu. |
| `<leader>lL` | `:LangSelect` | Open the Unified Language Settings popup (Ask vs Default). |
| `<leader>lg` | `:LeetLang` | Switch or add another language for the active question. |

---

## 6. Niri Window Focus & Cursor Visibility Fix

Configured in [`lua/core/options.lua`](file:///home/saksham/.config/nvim/lua/core/options.lua) and [`lua/autocmds.lua`](file:///home/saksham/.config/nvim/lua/autocmds.lua).

### 🔍 Issue & Root Cause
- Under Wayland compositors (specifically Niri tiling window manager), moving focus away from the Neovim window and focusing back caused the terminal cursor to vanish or fail to redraw.

### 🛡️ Solution Applied
1. **Focus Synchronization**: Added a dedicated `FocusGained` and `ColorScheme` autocmd (`sync_terminal_cursor`):
   - Emits `\027[?25h` (ANSI unhide cursor escape code).
   - Dynamically checks current mode (`n`, `i`, `v`, `R`) and asserts the appropriate cursor shape (`\027[1 q` block for normal, `\027[5 q` blinking beam for insert).
   - Re-syncs Neovim's internal TUI cursor state (`vim.go.guicursor = vim.go.guicursor`) and schedules an immediate redraw (`vim.cmd("redraw")`).
2. **Zed-Style Cursor Animation**:
   - Smooth blink timing: 700ms wait, 500ms on, 400ms off. The cursor blinks gently while idle and remains solidly visible while typing.
   - Clean cursor restoration on exit (`VimLeavePre`) via `\027[0 q`.

---

## 7. Multi-Language LSP & Syntax Diagnostics Engine

Configured in [`lua/plugins/lsp.lua`](file:///home/saksham/.config/nvim/lua/plugins/lsp.lua).

Competitive programming files and LeetCode problems exist outside standard Cargo, Gradle, or CMake build trees. Standard language servers typically report nothing or crash when files lack a project root. We engineered auto-provisioning systems that deliver 100% full, live semantic and syntax diagnostics across all 5 languages:

### 🦀 1. Rust (`rust-analyzer`)
- **Root Provisioning (`ensure_rust_project`)**: Whenever a `.rs` file in `~/leetcode` or `~/cp` is opened, Neovim automatically discovers your active Rust toolchain sysroot (`rustc --print sysroot`) and constructs a valid `rust-project.json` on the fly.
- **Identifier Sanitization**: Automatically normalizes file names with leading digits or dots (e.g., `31.next-permutation.rs` ➔ `c_31_next_permutation`) so rustc accepts the crate name.
- **In-Memory Salsa Analysis**: For standalone files without a `Cargo.toml`, sets `check = { enable = false }` so `rust-analyzer` uses its instant built-in compiler analysis instead of looking for `cargo`. Syntax errors, missing types, and invalid expressions report immediately with live red underlines while typing.
- **LeetCode Scope Fix**: Automatically injects `struct Solution;` so LeetCode methods (`impl Solution { ... }`) compile with zero scope errors.

### ⚡ 2. C & C++ (`clangd`)
- Full background indexing, clang-tidy integration, detailed completion styles, and automated header insertion. Works out of the box on standalone `.cpp` and `.c` files with standard library headers (`<bits/stdc++.h>`, `<iostream>`, `<stdio.h>`).

### 🐍 3. Python (`pyright` + `ruff`)
- Combined type analysis and linting. Replaced 35 lines of wildcard imports in LeetCode with clean `from typing import *`, eliminating false positive undefined variable or unused import warnings.

### ☕ 4. Java (`jdtls`) & Java Swing GUI Workflows
- **Automated Eclipse Project Provisioning**: When opening any `.java` file in a standalone directory, Neovim auto-generates `.project` and `.classpath` referencing the local JRE container.
- **Full Project Diagnostics**: JDTLS operates in full semantic project mode with zero non-project warnings (benign classpath notices are filtered out cleanly in `publishDiagnostics`).
- **Java Swing GUI Support**:
  - `<leader>js`: **Run Swing GUI (Interactive)** — Compiles and launches the active Swing window in a terminal split. Automatically applies Wayland/Hyprland non-reparenting flags (`_JAVA_AWT_WM_NONREPARENTING=1`) and crisp subpixel font anti-aliasing (`-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true`). If compilation fails, pauses the terminal with clear diagnostics so output is never cut off.
  - `<leader>jS`: **Run Swing GUI (Background Detached)** — Asynchronously compiles the code, displays any errors via quickfix/notifications, and launches the Swing GUI window in the background without tying up Neovim.
  - `<leader>jw` / `:JavaSwingTemplate`: **Insert Swing Template** — Populates an empty `.java` buffer with modern Java Swing boilerplate: system Look & Feel, Event Dispatch Thread (`SwingUtilities.invokeLater`), centered `JFrame`, responsive `JPanel`, `JLabel`, `JTextField`, and an interactive `JButton` with lambda action listener.
  - `<leader>jr`: Run standard Java main class or project (Maven / Gradle / standalone).
  - `<leader>jt`: Run project test suite (`mvn test` / `gradle test`).
  - `<leader>jb`: Build workspace / compile current file.
  - `<leader>jc`: Clean JDTLS workspace cache and restart LSP.
- **Java Swing Snippets**: Comprehensive set of 20+ snippets registered in `~/.config/nvim/snippets/java.json` (`swingapp`, `jframe`, `swingmain`, `jbutton`, `jlabel`, `jtextfield`, `jtextarea`, `jpanel`, `jdialog`, `jmenu`, `jtable`, `jcombobox`, `jcheckbox`, `jradiobutton`, `joptionpane`, `jconfirm`, `actionlistener`, `mouselistener`, `swingworker`, `gridbag`, `lookandfeel`).
- **LSP Auto-Imports for Swing**: JDTLS pre-configured with favorite static completions for `javax.swing.SwingUtilities.*`, `javax.swing.JOptionPane.*`, `java.awt.BorderLayout.*`, `java.awt.Color.*`, `java.awt.Font.*`.

### 🩺 Universal Diagnostic Presentation (Standardized Across All Languages)
- **Clean Canvas (No Virtual Text)**: Inline virtual text is strictly disabled (`virtual_text = false`). No error messages clutter the end of lines—your code remains clean and legible just like in Java and C++.
- **Underline & Gutter Symbol Only**: Errors and warnings are visually represented solely by:
  - **Syntax Underlines**: Razor-sharp colored underlines directly under erroneous syntax tokens (`underline = true`).
  - **Gutter Signs**: High-visibility icons in the signcolumn (` ` Error, ` ` Warning, ` ` Info, ` ` Hint).
- **Normal Mode Hover Popup Only**: Error detail cards appear in a floating popup *only* when in **normal mode** and hovering on the error:
  - **Automatic Hover (`CursorHold`)**: Resting the cursor over an underlined error for 300ms in normal mode automatically displays the floating diagnostic card with rounded borders and icons. Moving the cursor or switching modes dismisses it instantly.
  - **Keyboard Trigger (`K`)**: Pressing `K` while positioned on an error opens the floating diagnostic card with keyboard focus (allowing text selection/copying); pressing `K` on valid code shows standard LSP documentation.
- **Unobstructed Typing in Insert Mode**: Underlines and gutter signs update live as you type (`update_in_insert = true`), but popup cards are completely suppressed so they never interrupt your flow.
- **Universal Standard**: Configured at the global engine level in `vim.diagnostic.config` to automatically apply across LeetCode (`~/leetcode/`), Codeforces (`~/cp/`), and every language (Rust, C++, Java, Python, C, Go, etc.).

---

## 8. Unified Language Picker & Dynamic Manager

Configured in [`lua/plugins/lang_picker.lua`](file:///home/saksham/.config/nvim/lua/plugins/lang_picker.lua). This system orchestrates language selection across both **LeetCode** and **Codeforces (Competitive Companion / cph)**.

### 🌐 Supported Languages
1. **C++** (`.cpp`) — `leetcode: cpp`, `cph: cpp`
2. **Python** (`.py`) — `leetcode: python3`, `cph: python`
3. **Java** (`.java`) — `leetcode: java`, `cph: java`
4. **Rust** (`.rs`) — `leetcode: rust`, `cph: rust`
5. **C** (`.c`) — `leetcode: c`, `cph: c`

### 🔄 The Two Operational Modes
1. **"Ask Every Time" Mode (`mode = "ask"`)**:
   - Whenever you open any LeetCode problem or import a Codeforces problem via Competitive Companion, an interactive Telescope popup prompts you to choose your desired language.
   - Shows badges indicating which languages you have already implemented for that specific problem.
2. **"Default Language" Mode (`mode = "default"`)**:
   - Never prompts. Instantly opens or creates the problem in your configured default language (e.g. C++, Rust, or Python).

### 🎛️ Settings Popup & Commands
- **`<leader>lL`** or **`<leader>cL`** or **`:LangSelect`**: Opens the Language Settings Popup:
  ```
  ⚙️  Unified Language Settings (LeetCode & Codeforces CP)
  ─────────────────────────────────────────────────────────────────────────────
  󰄲 Mode: Ask Every Time           │ Prompt me to choose a language for every question
  󰄱 Mode: Use Default Language     │ Never prompt; always use default (C++ (Fast I/O))
  ─────────────────────────────────────────────────────────────────────────────
   Set Default: C++               │ Fast I/O, bits/stdc++.h, C++20
   Set Default: Rust              │ High safety, memory efficient, 2021 edition
   Set Default: Python            │ Fast development, type annotations
   Set Default: Java              │ FastScanner, PrintWriter template
   Set Default: C                 │ Pure ANSI C / C11, minimal overhead
  ```
- **`<leader>cT`** or **`:LangToggle`**: Quick single-keystroke toggle between "Ask Every Time" and "Default Language" mode without opening the menu.
- **Settings Storage**: Persisted in `~/.local/share/nvim/cp_language_settings.json`.

### 📂 Multi-Language Coexistence (Files Never Overwritten)
- **LeetCode**: If you solve Two Sum in C++ (`1.two-sum.cpp`), selecting Rust later generates `1.two-sum.rs`. Both files coexist independently in `~/leetcode/`.
  - Press **`<leader>lg`** or **`:LeetLang`** on any active LeetCode problem to instantly switch to or create another language solution.
- **Codeforces**: If you solve Problem A in C++ (`solution.cpp`), selecting Rust creates `solution.rs` and configures `rust-project.json`.
  - Press **`<leader>cg`** or **`:CpLang`** inside any problem directory to add or switch to another language solution.

---

## 9. Competitive Programming Fast I/O Templates

Located in [`~/cp/templates/`](file:///home/saksham/cp/templates/). When a new solution file is created in `~/cp/`, the appropriate template is automatically populated:

### 1. C++ (`template.cpp`)
```cpp
#include <bits/stdc++.h>
using namespace std;

#define fast_io ios_base::sync_with_stdio(false); cin.tie(NULL);
#define all(x) (x).begin(), (x).end()

typedef long long ll;

void solve() {}

int main() {
    fast_io;
    int t = 1;
    cin >> t;
    while (t--) {
        solve();
    }
    return 0;
}
```

### 2. Rust (`template.rs`)
```rust
use std::io::{self, BufRead};

fn solve() {
    // Write solution here
}

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    if let Some(Ok(first_line)) = lines.next() {
        if let Ok(t) = first_line.trim().parse::<usize>() {
            for _ in 0..t {
                solve();
            }
        }
    }
}
```

### 3. Python (`template.py`)
```python
import sys

# Fast I/O
input = sys.stdin.readline

def solve():
    # Write solution here
    pass

def main():
    t_str = input().strip()
    if not t_str:
        return
    t = int(t_str)
    for _ in range(t):
        solve()

if __name__ == "__main__":
    main()
```

### 4. Java (`template.java`)
```java
import java.io.*;
import java.util.*;

public class solution {
    static FastScanner fs = new FastScanner();
    static PrintWriter out = new PrintWriter(System.out);

    static void solve() {
        // Write solution here
    }

    public static void main(String[] args) {
        int t = 1;
        if (fs.hasNext()) {
            t = fs.nextInt();
        }
        while (t-- > 0) {
            solve();
        }
        out.flush();
    }

    static class FastScanner {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer("");

        String next() {
            while (!st.hasMoreTokens()) {
                try {
                    String line = br.readLine();
                    if (line == null) return null;
                    st = new StringTokenizer(line);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return st.nextToken();
        }

        boolean hasNext() {
            while (!st.hasMoreTokens()) {
                try {
                    String line = br.readLine();
                    if (line == null) return false;
                    st = new StringTokenizer(line);
                } catch (IOException e) {
                    return false;
                }
            }
            return true;
        }

        int nextInt() {
            return Integer.parseInt(next());
        }
    }
}
```

### 5. C (`template.c`)
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void solve(void) {
    // Write solution here
}

int main(void) {
    int t = 1;
    if (scanf("%d", &t) == 1) {
        while (t--) {
            solve();
        }
    }
    return 0;
}
```

---

## 10. Neo-tree & Project File Navigation Suite

Implemented in [`lua/plugins/neotree_nav.lua`](file:///home/saksham/.config/nvim/lua/plugins/neotree_nav.lua). This system provides instantaneous tree traversal, seamless directory crossing, and file explorer workflows directly from normal mode in your editor buffer:

### ⚡ Seamless Sequential Tree Traversal
- **`<leader>nd` (Next File Down in Tree)**: Moves to the file below the current one in the project tree hierarchy.
  - When the files in the current folder get over, it **automatically enters the next folder** and opens its first file.
  - If you reach the very end of the project tree, it wraps around cleanly to the start with a notification (`🔁 [Wrapped to Start]`).
- **`<leader>nu` (Previous File Up in Tree)**: Moves to the file above the current one.
  - Automatically crosses backward over directory boundaries into the previous folder.
- **`<leader>ns` (Next Sibling File)**: Cycles to the next file strictly within the *same* directory (without entering subdirectories or jumping away).
- **`<leader>np` (Previous Sibling File)**: Cycles to the previous file strictly within the *same* directory.

### 🚀 Directory Leaping & Structural Navigation
- **`<leader>nD` (Next Directory Jump)**: Skips all remaining files in the current folder and leaps directly to the first file in the *next* directory.
- **`<leader>nU` (Previous Directory Jump)**: Leaps to the first file of the *previous* directory.
- **`<leader>nh` (Parent Directory File)**: Jumps up one level to the first file in the parent folder.

### 🌿 Git Modified File Leaping
- **`<leader>ng` (Next Git Modified File)**: Instantly jumps to the next uncommitted, modified, or untracked file across the entire project.
- **`<leader>nG` (Previous Git Modified File)**: Jumps to the previous uncommitted or modified file.

### 🪟 Neo-tree Explorer Controls & Path Utilities
- **`<leader>ne`** / **`<leader>nf`**: Reveal the current file in Neo-tree and focus the explorer cursor on it.
- **`<leader>nt`**: Toggle the Neo-tree sidebar on the right.
- **`<leader>no`**: Open Neo-tree in a centered floating modal window.
- **`<leader>nr`**: Refresh the tree explorer and clear the file navigation cache.
- **`<leader>nb`**: Open Neo-tree in buffer-list explorer mode.
- **`<leader>ny`**: Copy relative file path (e.g. `lua/plugins/neotree.lua`) to system clipboard.
- **`<leader>nY`**: Copy absolute file path to system clipboard.

---

## 11. Master Keymaps Cheat Sheet

### 󰙅 Neo-tree & Project File Navigation
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>nd` | Next File Down | Move to file below in tree (auto-enters next folder) |
| `<leader>nu` | Prev File Up | Move to file above in tree (auto-enters prev folder) |
| `<leader>ns` | Next Sibling | Next file strictly within the same folder |
| `<leader>np` | Prev Sibling | Previous file strictly within the same folder |
| `<leader>nD` | Next Directory | Leap to first file of next directory |
| `<leader>nU` | Prev Directory | Leap to first file of previous directory |
| `<leader>nh` | Parent Folder File | Jump up to file in parent directory |
| `<leader>ng` | Next Git Modified | Jump to next uncommitted/changed file |
| `<leader>nG` | Prev Git Modified | Jump to previous uncommitted/changed file |
| `<leader>ne` / `<leader>nf` | Reveal & Focus | Reveal active file in Neo-tree and focus sidebar |
| `<leader>nt` | Toggle Explorer | Toggle Neo-tree sidebar on the right |
| `<leader>no` | Float Explorer | Open Neo-tree in centered floating popup |
| `<leader>nr` | Refresh Tree | Rescan project files and clear nav cache |
| `<leader>nb` | Buffers Explorer | Open Neo-tree in active buffers mode |
| `<leader>ny` | Copy Relative Path | Copy relative path to clipboard |
| `<leader>nY` | Copy Absolute Path | Copy absolute path to clipboard |

### 🎯 LeetCode Workflow
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>ld` | `:Leet daily` | Daily challenge question picker |
| `<leader>lq` | Today's Question | Instantly open today's challenge |
| `<leader>le` | `:Leet easy` | Browse Easy problems |
| `<leader>lm` | `:Leet medium` | Browse Medium problems |
| `<leader>lh` | `:Leet hard` | Browse Hard problems |
| `<leader>lu` | `:Leet unsolved` | Browse Unsolved problems |
| `<leader>lS` | `:Leet solved` | Browse Solved problems |
| `<leader>lT` | `:Leet topics` | Browse by topic tag |
| `<leader>lR` | `:Leet random` | Open a random problem |
| `<leader>lr` | `:Leet reset` | Reset solution code back to starter template |
| `<leader>lx` | `:Leet reset` | Reset solution code back to starter template (alias) |
| `<leader>lt` | `:Leet run` | Run default test cases against solution |
| `<leader>lT` | `:Leet test` | Run custom test cases |
| `<leader>ls` | `:Leet submit` | Submit solution to LeetCode judges |
| `<leader>lc` | `:Leet console` | Toggle test execution console |
| `<leader>li` | `:Leet info` | Toggle problem statistics sidebar |
| `<leader>lD` | `:Leet desc` | Toggle description split on left |
| `<leader>lH` | `:Leet hints` | View hints for current problem |
| `<leader>lo` | `:Leet open` | Open problem in web browser |
| `<leader>ly` | `:Leet yank` | Copy solution code to clipboard |
| `<leader>lX` | `:Leet reset` | Reset problem starter code |
| `<leader>lP` | `:Leet last_submit` | Inspect last accepted submission |
| `<leader>lM` | `:Leet menu` | Open LeetCode dashboard |
| `<leader>lU` | `:Leet cache update`| Update question list cache |
| `<leader>lL` | `:LangSelect` | Open Language Settings (Ask vs Default) |
| `<leader>lg` | `:LeetLang` | Switch/Add language for current problem |

### 🏆 Competitive Programming & Codeforces
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>cr` | `:CphReceive` | Start listening for problems from Competitive Companion |
| `<leader>cs` | `:CphStop` | Stop listening for problems |
| `<leader>ct` / `<leader>cc` | `:CphTest` | Compile code and run all test cases |
| `<leader>cd` | `:CphRetest` | Retest cases without recompiling |
| `<leader>ce` | `:CphEdit 1` | Edit sample test case #1 |
| `<leader>cx` | Close Results | Close test case results window |
| `<leader>cL` | `:LangSelect` | Language Settings Popup (Ask vs Default) |
| `<leader>cg` | `:CpLang` | Switch/Add language solution in problem directory |
| `<leader>cT` | `:LangToggle` | Instant toggle between Ask and Default mode |

### 🎨 Themes & UI Appearance
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>th` | `:ThemeSelect` | 40-Theme Switcher popup with live scroll preview |
| `<leader>tc` | `:CurrentTheme`| Display active theme details card |
| `:ToggleVSCodeComments` | Toggle Comments | Switch between theme-native and VS Code green comments |
| `<leader>ti` / `<leader>ug` | `:ToggleIndentGuides` | Toggle indentation vertical guides on/off |
| `<leader>to` | `:CycleIndentOpacity` | Cycle guide line opacity: Subtle ➔ Medium ➔ High |

### 🔤 Typography & Fonts
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>fc` | `:FontCustomize` | Interactive Control Panel (size, spacing, weight, ligatures) |
| `<leader>fp` | `:FontSelect` | 30-Font Switcher popup with live preview |
| `<leader>fi` | `:CurrentFont` | Display active font specifications card |
| `<leader>f+` | Size Up | Bump font size up by +0.5pt |
| `<leader>f-` | Size Down | Bump font size down by -0.5pt |
| `<leader>f0` | Reset Defaults | Restore default font size and spacing |

### 🩺 LSP, Diagnostics & Code Intelligence
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `gd` | Definition | Jump to symbol definition |
| `gr` | References | Find all symbol references |
| `gi` / `gI` | Implementation | Jump to implementation |
| `gy` | Type Definition | Jump to type definition |
| `gD` | Declaration | Jump to declaration |
| `K` | Hover Info | Show error card (if on error) or LSP docs |
| `gK` / `<C-k>` | Signature Help | Display function parameter signatures |
| `<leader>ca` | Code Action | Open available code actions |
| `<leader>rn` | Rename Symbol | Project-wide symbol rename |
| `<leader>cl` | `:LspInfo` | Inspect active LSP clients |
| `gl` / `<leader>d` | Line Diagnostics | Open floating diagnostic card for current line |
| `]d` | Next Diagnostic | Jump to next error or warning |
| `[d` | Prev Diagnostic | Jump to previous error or warning |
| `<leader>f` | Format Document | Format file with configured linter/formatter |

---
*Created and maintained in your Neovim environment (`~/.config/nvim`).*
