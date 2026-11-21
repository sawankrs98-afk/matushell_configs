# Phase 3: VSCode-like File Explorer & Navigation

**Status**: ✅ Complete  
**Priority**: High  
**Estimated Time**: 2-3 hours  
**Dependencies**: Phase 2 complete

---

## 🎯 Objectives

1. Enhance Neo-tree with VSCode-style layout and icons
2. Improve Telescope fuzzy finder with better previews
3. Add breadcrumbs/winbar for navigation context
4. Optimize file navigation workflows
5. Add recent files tracking
6. Improve Oil.nvim integration

---

## 🔧 Tasks

### 1. Enhance Neo-tree Configuration

**Current State**: Basic Neo-tree setup  
**Target**: VSCode-like file explorer

**Enhancements**:

```lua
require("neo-tree").setup({
  -- VSCode-like positioning
  window = {
    position = "left",
    width = 35,  -- VSCode default sidebar width
    mapping_options = {
      noremap = true,
      nowait = true,
    },
  },
  
  -- Better filesystem display
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules",
        ".git",
        ".cache",
      },
      never_show = {
        ".DS_Store",
        "thumbs.db",
      },
    },
    follow_current_file = {
      enabled = true,  -- Auto-reveal file in tree
      leave_dirs_open = false,
    },
    use_libuv_file_watcher = true,  -- Auto-refresh
    window = {
      mappings = {
        -- VSCode-like mappings
        ["<space>"] = "none",
        ["<cr>"] = "open",
        ["<esc>"] = "cancel",
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["l"] = "open",
        ["h"] = "close_node",
        ["a"] = { 
          "add",
          config = {
            show_path = "relative" -- VSCode style
          }
        },
        ["d"] = "delete",
        ["r"] = "rename",
        ["c"] = "copy",
        ["x"] = "cut",
        ["p"] = "paste",
        ["y"] = "copy_to_clipboard",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
        ["<C-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
      },
    },
  },
  
  -- Git integration
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["u"] = "git_unstage_file",
        ["a"] = "git_add_file",
        ["r"] = "git_revert_file",
        ["c"] = "git_commit",
        ["p"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
  
  -- Better rendering
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      folder_empty_open = "",
      default = "",
    },
    modified = {
      symbol = "●",
      highlight = "NeoTreeModified",
    },
    git_status = {
      symbols = {
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "󰁕",
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      },
    },
  },
})
```

**Files to Modify**:
- `lua/modules/editor/neotree.lua`

---

### 2. Enhance Telescope Configuration

**VSCode-like Features**:
- Better layout (dropdown or centered)
- File preview
- Recent files integration
- Better sorting

**Configuration**:

```lua
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    -- VSCode-like layout
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    
    -- Better sorting
    sorting_strategy = "ascending",
    
    -- File ignore patterns
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "%.lock",
      "__pycache__",
      "%.o",
      "%.a",
      "%.out",
      "%.class",
      "%.pdf",
      "%.mkv",
      "%.mp4",
      "%.zip",
    },
    
    -- Better preview
    preview = {
      treesitter = true,
      mime_hook = function(filepath, bufnr, opts)
        local is_image = function(fp)
          local image_extensions = {'png','jpg','jpeg','gif','webp'}
          local split_path = vim.split(fp:lower(), '.', {plain=true})
          local extension = split_path[#split_path]
          return vim.tbl_contains(image_extensions, extension)
        end
        if is_image(filepath) then
          local term = vim.api.nvim_open_term(bufnr, {})
          local function send_output(_, data, _ )
            for _, d in ipairs(data) do
              vim.api.nvim_chan_send(term, d..'\r\n')
            end
          end
          vim.fn.jobstart({
            'chafa', filepath  -- or use 'catimg' or 'viu'
          }, {on_stdout=send_output, stdout_buffered=true})
        else
          require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
        end
      end
    },
    
    -- VSCode-like mappings
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["?"] = actions.which_key,
      },
    },
  },
  
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = true,
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    live_grep = {
      theme = "ivy",
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      sort_lastused = true,
      sort_mru = true,
    },
    recent_files = {
      theme = "dropdown",
      previewer = false,
    },
  },
  
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load extensions
telescope.load_extension("fzf")
telescope.load_extension("ui-select")
```

**Files to Modify**:
- `lua/modules/editor/telescope.lua`

---

### 3. Add Breadcrumbs / Winbar

**Purpose**: Show file location context like VSCode

**Install Plugin**:
```lua
vim.pack.add({
  { src = "https://github.com/utilyre/barbecue.nvim" },
  { src = "https://github.com/SmiteshP/nvim-navic" },
})
```

**Configuration**:

```lua
-- Navic (LSP-based breadcrumbs)
local navic = require("nvim-navic")

navic.setup({
  icons = {
    File          = " ",
    Module        = " ",
    Namespace     = " ",
    Package       = " ",
    Class         = " ",
    Method        = " ",
    Property      = " ",
    Field         = " ",
    Constructor   = " ",
    Enum          = " ",
    Interface     = " ",
    Function      = " ",
    Variable      = " ",
    Constant      = " ",
    String        = " ",
    Number        = " ",
    Boolean       = " ",
    Array         = " ",
    Object        = " ",
    Key           = " ",
    Null          = " ",
    EnumMember    = " ",
    Struct        = " ",
    Event         = " ",
    Operator      = " ",
    TypeParameter = " ",
  },
  highlight = true,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
  safe_output = true,
})

-- Barbecue (VSCode-style winbar)
require("barbecue").setup({
  theme = "auto",
  include_buftypes = { "" },
  exclude_filetypes = { "netrw", "toggleterm", "neo-tree" },
  show_dirname = true,
  show_basename = true,
  show_modified = true,
  modified = function(bufnr)
    return vim.bo[bufnr].modified
  end,
  symbols = {
    modified = "●",
    ellipsis = "…",
    separator = "",
  },
  kinds = {
    -- Same icons as navic
  },
})

-- Attach navic to LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end,
})
```

**Files to Create**:
- `lua/modules/ui/breadcrumbs.lua`

---

### 4. Add Recent Files Tracking

**Create**: `lua/modules/editor/frecency.lua`

**Purpose**: Smart recent files (frequency + recency)

**Install**:
```lua
vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope-frecency.nvim" },
})
```

**Configuration**:
```lua
require("telescope").setup({
  extensions = {
    frecency = {
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*", "*/node_modules/*"},
      disable_devicons = false,
      workspaces = {
        ["conf"]    = vim.env.HOME .. "/.config",
        ["project"] = vim.env.HOME .. "/projects",
        ["cp"]      = vim.env.HOME .. "/cp",
      }
    }
  }
})

require('telescope').load_extension('frecency')
```

**Keybinding**:
```lua
-- In lua/core/keymaps.lua
map("n", "<leader>fr", "<cmd>Telescope frecency<cr>", { desc = "Recent Files (Frecency)" })
map("n", "<C-r>", "<cmd>Telescope frecency<cr>", { desc = "Recent Files" })
```

**Files to Create**:
- `lua/modules/editor/frecency.lua`

---

### 5. Improve Oil.nvim Configuration

**Better file editing as buffer**:

```lua
require("oil").setup({
  default_file_explorer = false,  -- Let neo-tree be default
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "yes:2",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 2000,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-x>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  use_default_keymaps = true,
  view_options = {
    show_hidden = false,
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    is_always_hidden = function(name, bufnr)
      return false
    end,
  },
  float = {
    padding = 2,
    max_width = 100,
    max_height = 40,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
})
```

**Files to Modify**:
- `lua/modules/editor/oil.lua`

---

### 6. Add Project Switcher

**Install**:
```lua
vim.pack.add({
  { src = "https://github.com/ahmedkhalf/project.nvim" },
})
```

**Configuration**:
```lua
require("project_nvim").setup({
  detection_methods = { "pattern", "lsp" },
  patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "go.mod" },
  show_hidden = false,
  silent_chdir = true,
  datapath = vim.fn.stdpath("data"),
})

-- Telescope integration
require('telescope').load_extension('projects')
```

**Keybinding**:
```lua
map("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Find Projects" })
```

**Files to Create**:
- `lua/modules/editor/projects.lua`

---

## 📋 Implementation Checklist

- [ ] Enhance Neo-tree with VSCode layout
- [ ] Improve Telescope configuration
- [ ] Add breadcrumbs/winbar (barbecue + navic)
- [ ] Add frecency for recent files
- [ ] Improve Oil.nvim config
- [ ] Add project switcher
- [ ] Add keybindings for all new features
- [ ] Test file navigation workflows
- [ ] Update documentation

---

## 🧪 Testing Plan

1. **Neo-tree**:
   - Open with `Space e`
   - Test file creation/deletion
   - Verify auto-reveal works
   - Test git integration

2. **Telescope**:
   - Test `Ctrl+P` for files
   - Test live grep
   - Test buffer switcher
   - Verify previews work

3. **Breadcrumbs**:
   - Open a code file
   - Verify winbar shows file path and symbols
   - Test clicking on breadcrumb segments

4. **Recent Files**:
   - Open several files
   - Use `Space fr` to open recent
   - Verify frequency sorting

---

## 📊 Success Criteria

- ✅ Neo-tree looks and feels like VSCode Explorer
- ✅ Telescope has clean, consistent layouts
- ✅ Breadcrumbs show file context
- ✅ Recent files are easily accessible
- ✅ Navigation feels smooth and intuitive
- ✅ All keybindings are VSCode-like

---

## 📝 Notes

- Consider adding file bookmarks plugin
- May want to add harpoon for file marking
- Consider adding aerial.nvim for symbol outline

---

**Next Phase**: Phase 4 - LSP & Completion Enhancement
