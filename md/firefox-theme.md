# Safari macOS Tahoe Dark Theme for Firefox

A pixel-faithful, authentic replica of **Safari macOS Tahoe Dark Mode** running on Mozilla Firefox 157. Engineered with precision layout proportions, native macOS window controls, spring physics tab animations, a floating glass findbar, and a real-time JS-driven loading progress bar. Packaged for zero-symlink multi-distribution portability.

---

## 1. Visual Discrepancies Resolved (1:1 Safari Replica)

| Component | Upstream / Initial State | Final Safari Tahoe Dark Mode Replica |
| :--- | :--- | :--- |
| **Window Traffic Lights** | Trapped on the far right edge next to hamburger button. | Pinned to the **far left** (`left: 16px; top: 50%; transform: translateY(-50%)`), 12×12px circles with 8px gaps in exact macOS order: Red (`#fe6254`), Yellow (`#f1ae1b`), Green (`#59c837`). Hover reveals authentic `✕`, `−`, `↗` glyphs. |
| **Top Header Bar Height** | Bulky 60px height in multi-tab and 52px in single-tab. | Slim, fixed **50px** Safari Tahoe header bar height with `padding-inline-start: 78px` (clearing left traffic lights) and a subtle `1px solid rgba(255, 255, 255, 0.08)` separator beneath. |
| **Address Bar (URL Bar)** | Oversized 44px height stretching across the entire screen. | Compact **34px** height pill (`border-radius: 9999px`), centered horizontally (`max-width: 680px`), translucent background `rgba(255, 255, 255, 0.07)`, and Apple blue focus glow `rgba(0, 122, 255, 0.45)`. |
| **Domain Shortening** | URL bar showed full raw URLs at all times. | `urlbar.uc.js` shortens URL to eTLD+1 (e.g. `gemini.google.com` or `masterclass.com`), calculates canvas text width, and centers it in the pill. Expands to full editable URL instantly upon click. |
| **Search Dropdown Chevron** | Annoying `Q v` search engine dropdown arrow inside the pill. | Completely hidden `#urlbar-searchmode-switcher` and identity dropdown markers to match genuine minimalist Safari appearance. |
| **Reload / Stop Button** | Located outside the URL bar on the left toolbar. | Moved inside the URL bar pill on the right interior edge (`right: 6px`), sized 24×24px with 13px symbolic SVG icon. |
| **Loading Progress Bar** | Broken CSS-only 300s scaleX simulation. | Real-time JS-driven progress bar (`urlbar.uc.js` TabsProgressListener) controlling `--safari-progress` scaleX (0.0 → 1.0) along a 2px blue-to-cyan gradient line at the bottom edge of the pill. |
| **Left Navigation Controls** | Clunky square buttons with extraneous background box. | Sleek `38×32px` sidebar button with rounded corners (`8px`), followed by a joined `60×32px` D-shaped Back/Forward capsule (`rgba(255, 255, 255, 0.06)`). Forward dimmed to `0.35` opacity when inactive. |
| **Right Action Group** | Broken extensions, Firefox account avatar, and displaced buttons. | Clean unified `104×32px` capsule containing Downloads `(↓)`, New Tab `(+)`, and Hamburger Menu `(≡)` evenly distributed at 32px diameter. |
| **Safari Findbar** | Awkward full-width bottom bar. | Floating top-right frosted glass capsule (`rgba(30, 32, 33, 0.95)`, `blur(24px)`) positioned at `top: 96px; right: 24px` (adaptive `top: 60px` in single-tab mode), custom magnifying glass input, chevron buttons, and `Ctrl+F` / `F8` shortcut integration. |
| **Tab Animations** | Generic linear fade. | Safari spring physics easing `280ms cubic-bezier(0.4, 0, 0.2, 1)`. Tab bar automatically collapses away (`translateY(-100%)`, `opacity: 0`) in single-tab mode and expands smoothly in multi-tab mode. |
| **Autocomplete Dropdown** | Opaque grey `rgba(51, 51, 51, 0.95)`. | Deep dark frosted glass `rgba(28, 30, 30, 0.97)` with `blur(24px)` and Apple blue selected row highlight `rgba(0, 122, 255, 0.75)`. |
| **New Tab / Start Page** | Purple `#2b2a33` with weather, Pocket stories, and sponsored tiles. | Dark Apple system `#1c1c1e` with all telemetry, sponsored links, and clutter suppressed. |

---

## 2. Directory Architecture & Sync Trio

```
~/chrome/                          ← PRIMARY WORKING DIRECTORY
│
├── userChrome.css                 ← Main UI styling (header, URL bar, traffic lights)
├── userContent.css                ← Content page styling (about:newtab, about:preferences)
├── customChrome.css               ← Dark mode tokens, autocomplete palette, findbar
├── urlbar.uc.js                   ← Runtime JS: single-tab detection, URL centering, progress
├── userChrome.js                  ← Autoconfig loader
│
└── MacTahoe/                      ← Upstream theme parts & symbolic SVGs
    ├── parts/csd.css              ← Window control positioning (left traffic lights)
    ├── parts/titlebutton-dark.css ← macOS circle SVGs with hover glyphs
    └── parts/icons.css            ← Symbolic icon mappings

~/.mozilla/firefox/default/chrome/ ← LIVE PROFILE MIRROR (100% synced, 0 symlinks)

~/safari-firefox-theme/            ← PORTABLE PACKAGE (100% synced, 0 symlinks)
├── chrome/                        ← Full chrome folder
├── system/
│   ├── config.js                  ← /usr/lib/firefox/config.js
│   └── config-prefs.js            ← /usr/lib/firefox/defaults/pref/config-prefs.js
├── user.js                        ← Master profile preferences
└── install.sh                     ← Universal installer for fresh systems/distros
```

---

## 3. Strict Safety Guarantees

1. **Zero Symlinks**: All files across `~/.mozilla/firefox/default/` and `~/safari-firefox-theme/` are real physical copies. This prevents broken symlinks across different filesystems or Linux distributions.
2. **Zen Browser Complete Isolation**: Zen Browser (PID 87901 running at `/opt/zen-browser-bin/zen-bin` with profile at `~/.config/zen/`) operates in complete isolation. No Zen Browser files, processes, or configurations were modified or touched.
