# Phase 5: UI/UX Polish (Statusline, Bufferline, Colors)

**Status**: ✅ Complete  
**Priority**: Medium  
**Estimated Time**: 2-3 hours  
**Dependencies**: Phase 2-4 complete

---

## 🎯 Objectives

1. Enhance Lualine with VSCode-like components
2. Improve Bufferline with better icons and separation
3. Optimize color scheme loading and fallbacks
4. Add smooth scrolling and animations
5. Improve indent guides with rainbow colors
6. Polish cursor animations
7. Add better notifications

---

## 🔧 Tasks

### 1. Enhance Lualine (Statusline)

**VSCode-like statusline**:

```lua
local function lsp_client_names()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return "  " .. table.concat(names, ", ")
end

local function python_env()
  if vim.bo.filetype == "python" then
    local venv = vim.env.VIRTUAL_ENV
    if venv then
      return string.format(" %s", vim.fn.fnamemodify(venv, ":t"))
    end
  end
  return ""
end

local function copilot_status()
  local ok, copilot = pcall(require, "copilot.api")
  if not ok then
    return ""
  end
  
  -- Check copilot status
  return ""  -- Customize based on copilot API
end

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha", "neo-tree", "toggleterm" },
      winbar = { "alpha", "neo-tree", "toggleterm" },
    },
    always_divide_middle = true,
    globalstatus = true,  -- Single statusline for all windows
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)  -- Show only first letter
        end,
      },
    },
    
    lualine_b = {
      {
        "branch",
        icon = "",
      },
      {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
      },
    },
    
    lualine_c = {
      {
        "filename",
        path = 1,  -- Relative path
        shorting_target = 40,
        symbols = {
          modified = " ●",
          readonly = " ",
          unnamed = "[No Name]",
          newfile = " ",
        },
      },
    },
    
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      },
      { copilot_status },
      { lsp_client_names },
      { python_env },
    },
    
    lualine_y = {
      {
        "encoding",
        fmt = function(str)
          return str:upper()
        end,
      },
      {
        "fileformat",
        symbols = {
          unix = "LF",
          dos = "CRLF",
          mac = "CR",
        },
      },
      "filetype",
    },
    
    lualine_z = {
      { "progress" },
      { "location" },
    },
  },
  
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "neo-tree", "toggleterm", "quickfix", "fugitive" },
})
```

**Files to Modify**:
- `lua/modules/ui/lualine.lua`

---

### 2. Enhance Bufferline

**Better buffer tabs**:

```lua
require("bufferline").setup({
  options = {
    mode = "buffers",
    themable = true,
    numbers = "none",
    close_command = function(bufnr)
      require("bufdelete").bufdelete(bufnr, false)
    end,
    right_mouse_command = function(bufnr)
      require("bufdelete").bufdelete(bufnr, false)
    end,
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    
    indicator = {
      icon = "▎",
      style = "icon",
    },
    
    buffer_close_icon = "󰅖",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    
    max_name_length = 25,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 22,
    
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "center",
        separator = true,
      },
    },
    
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    show_duplicate_prefix = true,
    persist_buffer_sort = true,
    move_wraps_at_ends = false,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    hover = {
      enabled = true,
      delay = 200,
      reveal = { "close" },
    },
    sort_by = "insert_after_current",
  },
  
  highlights = {
    fill = {
      bg = { attribute = "bg", highlight = "Normal" },
    },
    background = {
      italic = false,
    },
    buffer_selected = {
      bold = true,
      italic = false,
    },
    diagnostic_selected = {
      bold = true,
      italic = false,
    },
    info_selected = {
      bold = true,
      italic = false,
    },
    info_diagnostic_selected = {
      bold = true,
      italic = false,
    },
    warning_selected = {
      bold = true,
      italic = false,
    },
    warning_diagnostic_selected = {
      bold = true,
      italic = false,
    },
    error_selected = {
      bold = true,
      italic = false,
    },
    error_diagnostic_selected = {
      bold = true,
      italic = false,
    },
  },
})
```

**Files to Modify**:
- `lua/modules/ui/bufferline.lua`

---

### 3. Optimize Theme Loading

**Smart theme loader with fallback**:

```lua
-- lua/modules/ui/theme_loader.lua
local M = {}

M.themes = {
  "tokyonight",
  "catppuccin",
  "vscode",
  "gruvbox",
  "kanagawa",
  -- ... more themes
}

M.fallback_theme = "habamax"  -- Built-in fallback

function M.load_theme(name)
  -- Try to load theme
  local ok = pcall(vim.cmd, "colorscheme " .. name)
  
  if not ok then
    vim.notify(
      string.format("Failed to load theme '%s', using fallback '%s'", name, M.fallback_theme),
      vim.log.levels.WARN
    )
    pcall(vim.cmd, "colorscheme " .. M.fallback_theme)
    return false
  end
  
  return true
end

function M.setup_theme_picker()
  -- Telescope theme picker
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  
  pickers.new({}, {
    prompt_title = "Select Theme",
    finder = finders.new_table({
      results = M.themes,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          M.load_theme(selection[1])
        end
      end)
      return true
    end,
  }):find()
end

return M
```

**Files to Create**:
- `lua/modules/ui/theme_loader.lua`

---

### 4. Improve Indent Guides

**Rainbow indent guides**:

```lua
require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
    highlight = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    },
    smart_indent_cap = true,
    priority = 2,
  },
  
  whitespace = {
    highlight = {
      "Whitespace",
      "NonText",
    },
    remove_blankline_trail = true,
  },
  
  scope = {
    enabled = true,
    char = "│",
    show_start = true,
    show_end = true,
    show_exact_scope = true,
    injected_languages = true,
    highlight = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    },
    priority = 1024,
  },
  
  exclude = {
    filetypes = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
    buftypes = {
      "terminal",
      "nofile",
    },
  },
})

-- Rainbow delimiters for matching brackets
require("rainbow-delimiters.setup").setup({})
```

**Install**:
```lua
vim.pack.add({
  { src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
})
```

**Files to Modify**:
- `lua/modules/ui/indent.lua`

---

### 5. Add Smooth Scrolling

**Install**:
```lua
vim.pack.add({
  { src = "https://github.com/karb94/neoscroll.nvim" },
})
```

**Configuration**:
```lua
require("neoscroll").setup({
  mappings = {},  -- We'll use manual bindings
  hide_cursor = true,
  stop_eof = true,
  respect_scrolloff = false,
  cursor_scrolls_alone = true,
  easing_function = "quadratic",
  pre_hook = nil,
  post_hook = nil,
  performance_mode = false,
})

local t = {}
t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100" } }
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }
t["gg"] = { "scroll", { "-2*vim.api.nvim_win_get_height(0)", "true", "200" } }
t["G"] = { "scroll", { "2*vim.api.nvim_win_get_height(0)", "true", "200" } }

require("neoscroll.config").set_mappings(t)
```

**Files to Create**:
- `lua/modules/ui/scrolling.lua`

---

### 6. Improve Notifications

**Better nvim-notify**:

```lua
require("notify").setup({
  background_colour = "#000000",
  fps = 60,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = "",
  },
  level = vim.log.levels.INFO,
  minimum_width = 50,
  render = "compact",
  stages = "fade_in_slide_out",
  timeout = 3000,
  top_down = true,
})

-- Set as default notify
vim.notify = require("notify")
```

**Files to Create**:
- `lua/modules/ui/notifications.lua`

---

### 7. Polish Alpha Dashboard

**Better start screen**:

```lua
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header
dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  "                                                     ",
  "              VSCode-like Experience                 ",
}

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", "  Recent files", ":Telescope frecency <CR>"),
  dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
  dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
  dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
  dashboard.button("l", "  LeetCode", ":Leet list <CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- Footer
local function footer()
  local total_plugins = #vim.tbl_keys(vim.g.plugs or {})
  local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
  local version = vim.version()
  local nvim_version = string.format(" v%d.%d.%d", version.major, version.minor, version.patch)
  
  return string.format("%s   %s plugins%s", datetime, total_plugins, nvim_version)
end

dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)
```

**Files to Modify**:
- `lua/modules/ui/alpha.lua`

---

## 📋 Implementation Checklist

- [ ] Enhance Lualine statusline
- [ ] Improve Bufferline appearance
- [ ] Create theme loader with fallback
- [ ] Add rainbow indent guides
- [ ] Implement smooth scrolling
- [ ] Improve notifications
- [ ] Polish Alpha dashboard
- [ ] Test all UI components
- [ ] Verify color consistency

---

## 🧪 Testing Criteria

- ✅ Statusline shows relevant info
- ✅ Bufferline looks clean and organized
- ✅ Theme switching works smoothly
- ✅ Scrolling is smooth
- ✅ Notifications are visible but not intrusive
- ✅ Dashboard is welcoming

---

**Next Phase**: Phase 6 - Terminal & Git Integration
