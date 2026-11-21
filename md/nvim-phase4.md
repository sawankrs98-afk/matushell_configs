# Phase 4: LSP & Completion Enhancement

**Status**: ✅ Complete  
**Priority**: Critical  
**Estimated Time**: 3-4 hours  
**Dependencies**: Phase 2 complete (lspconfig fix)

---

## 🎯 Objectives

1. Optimize Mason auto-installation
2. Enhance Blink.cmp with VSCode-like UI
3. Improve LSP handlers and diagnostics display
4. Configure inlay hints properly
5. Optimize formatting with conform.nvim
6. Add signature help improvements
7. Enhance hover documentation

---

## 🔧 Tasks

### 1. Optimize Mason Configuration

**Auto-install all required LSP servers**:

```lua
-- lua/modules/lsp/mason.lua
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup({
  ui = {
    border = "rounded",
    width = 0.8,
    height = 0.8,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  max_concurrent_installers = 10,
})

-- Auto-install LSP servers
mason_lspconfig.setup({
  ensure_installed = {
    -- Web Development
    "ts_ls",  -- TypeScript/JavaScript
    "html",
    "cssls",
    "jsonls",
    "tailwindcss",
    
    -- Backend
    "pyright",  -- Python
    "rust_analyzer",  -- Rust
    "gopls",  -- Go
    "jdtls",  -- Java
    
    -- Systems
    "clangd",  -- C/C++
    "zls",  -- Zig
    
    -- Config/Scripting
    "lua_ls",  -- Lua
    "bashls",  -- Bash
    "yamlls",  -- YAML
    
    -- Build systems
    "cmake",
  },
  automatic_installation = true,
})

-- Auto-install formatters, linters, debuggers
mason_tool_installer.setup({
  ensure_installed = {
    -- Formatters
    "prettier",  -- JS/TS/HTML/CSS
    "black",  -- Python
    "isort",  -- Python imports
    "stylua",  -- Lua
    "shfmt",  -- Shell
    "clang-format",  -- C/C++
    
    -- Linters
    "eslint_d",  -- JS/TS
    "ruff",  -- Python
    "shellcheck",  -- Shell
    "cpplint",  -- C++
    
    -- Debuggers
    "debugpy",  -- Python
    "codelldb",  -- Rust/C++
  },
  auto_update = true,
  run_on_start = true,
})
```

**Files to Create**:
- `lua/modules/lsp/mason.lua` (separate from lsp.lua)

---

### 2. Enhance Blink.cmp Configuration

**VSCode-like completion UI**:

```lua
require("blink.cmp").setup({
  keymap = {
    show = "<C-space>",
    hide = "<C-e>",
    accept = "<CR>",
    select_prev = { "<Up>", "<C-p>", "<S-Tab>" },
    select_next = { "<Down>", "<C-n>", "<Tab>" },
    
    show_documentation = "<C-space>",
    hide_documentation = "<C-space>",
    scroll_documentation_up = "<C-b>",
    scroll_documentation_down = "<C-f>",
    
    snippet_forward = "<Tab>",
    snippet_backward = "<S-Tab>",
  },
  
  accept = {
    create_undo_point = true,
    auto_brackets = {
      enabled = true,
      default_brackets = { "(", ")" },
      override_brackets_for_filetypes = {},
      force_allow_filetypes = {},
      blocked_filetypes = {},
      kind_resolution = {
        enabled = true,
        blocked_filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      },
    },
  },
  
  trigger = {
    completion = {
      keyword_range = "prefix",
      keyword_regex = "[%w_\\-]",
      exclude_from_prefix_regex = "[\\-]",
      show_on_keyword = true,
      show_on_trigger_character = true,
      show_on_accept_on_trigger_character = true,
      show_on_insert_on_trigger_character = true,
    },
    signature_help = {
      enabled = true,
      blocked_trigger_characters = {},
      blocked_retrigger_characters = {},
      show_on_insert_on_trigger_character = true,
    },
  },
  
  fuzzy = {
    use_typo_resistance = true,
    use_frecency = true,
    use_proximity = true,
    sorts = { "label", "kind", "score" },
  },
  
  sources = {
    completion = {
      enabled_providers = { "lsp", "path", "snippets", "buffer" },
    },
    providers = {
      lsp = {
        name = "LSP",
        module = "blink.cmp.sources.lsp",
        score_offset = 100,  -- Prioritize LSP
      },
      path = {
        name = "Path",
        module = "blink.cmp.sources.path",
        score_offset = 10,
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = function(context)
            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
          end,
          show_hidden_files_by_default = false,
        },
      },
      snippets = {
        name = "Snippets",
        module = "blink.cmp.sources.snippets",
        score_offset = 80,
        opts = {
          friendly_snippets = true,
          search_paths = { vim.fn.stdpath("config") .. "/snippets" },
          global_snippets = { "all" },
          extended_filetypes = {},
          ignored_filetypes = {},
        },
      },
      buffer = {
        name = "Buffer",
        module = "blink.cmp.sources.buffer",
        score_offset = 5,
        opts = {
          max_items = 5,
        },
      },
    },
  },
  
  windows = {
    autocomplete = {
      min_width = 30,
      max_width = 60,
      max_height = 15,
      border = "rounded",
      winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
      scrolloff = 2,
      scrollbar = true,
      direction_priority = { "s", "n" },
      auto_show = true,
      selection = "auto_insert",
      draw = "reversed",  -- VSCode-like: kind icon on left
    },
    documentation = {
      min_width = 10,
      max_width = 80,
      max_height = 20,
      border = "rounded",
      winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
      direction_priority = { "e", "w", "n", "s" },
      auto_show = true,
      auto_show_delay_ms = 500,
      update_delay_ms = 50,
    },
    signature_help = {
      min_width = 1,
      max_width = 100,
      max_height = 10,
      border = "rounded",
      winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
    },
  },
  
  highlight = {
    ns = vim.api.nvim_create_namespace("blink_cmp"),
    use_nvim_cmp_as_default = true,
  },
  
  kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
  },
})
```

**Files to Modify**:
- `lua/modules/lsp/blink.lua`

---

### 3. Improve LSP Diagnostics Display

**Better diagnostics UI**:

```lua
-- Diagnostic signs
local signs = {
  Error = "",
  Warn = "",
  Hint = "󰌵",
  Info = "",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = "if_many",
    format = function(diagnostic)
      -- Show source in brackets if available
      if diagnostic.source then
        return string.format("%s [%s]", diagnostic.message, diagnostic.source)
      end
      return diagnostic.message
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    focusable = false,
    style = "minimal",
    format = function(diagnostic)
      return string.format(
        "%s [%s]",
        diagnostic.message,
        diagnostic.source or diagnostic.code or ""
      )
    end,
  },
})

-- Better hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,
  max_height = 20,
})

-- Better signature help
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  focusable = false,
  relative = "cursor",
})
```

**Files to Modify**:
- `lua/modules/lsp/lsp.lua`

---

### 4. Configure Inlay Hints

**Enable inlay hints for supported servers**:

```lua
-- In LSP on_attach function
if client.server_capabilities.inlayHintProvider then
  -- Enable by default for Rust, TypeScript, etc.
  local ft = vim.bo[bufnr].filetype
  if vim.tbl_contains({ "rust", "typescript", "typescriptreact" }, ft) then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- Custom highlight
vim.api.nvim_set_hl(0, "LspInlayHint", {
  fg = "#6c7a89",
  italic = true,
})
```

**Files to Modify**:
- `lua/modules/lsp/lsp.lua`

---

### 5. Enhance Conform.nvim (Formatting)

**Better formatter configuration**:

```lua
local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- Web
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    
    -- Python
    python = { "isort", "black" },
    
    -- Lua
    lua = { "stylua" },
    
    -- C/C++
    c = { "clang_format" },
    cpp = { "clang_format" },
    
    -- Rust (use rustfmt from rust-analyzer)
    rust = { "rustfmt" },
    
    -- Go
    go = { "gofmt", "goimports" },
    
    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    
    -- Zig
    zig = { "zigfmt" },
  },
  
  format_on_save = function(bufnr)
    -- Disable autoformat for certain filetypes
    local ignore_filetypes = { "sql", "java" }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    
    -- Disable if file is too large
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return
    end
    
    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,
  
  format_after_save = {
    lsp_fallback = true,
  },
  
  log_level = vim.log.levels.ERROR,
  
  notify_on_error = true,
  
  formatters = {
    -- Custom formatter options
    prettier = {
      prepend_args = { "--single-quote", "--trailing-comma", "es5" },
    },
    black = {
      prepend_args = { "--line-length", "88" },
    },
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
  },
})

-- Format command
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  conform.format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
```

**Files to Modify**:
- `lua/modules/lsp/formatting.lua`

---

### 6. Add LSP Progress Indicator

**Enhance Fidget.nvim**:

```lua
require("fidget").setup({
  notification = {
    poll_rate = 10,
    filter = vim.log.levels.INFO,
    history_size = 128,
    override_vim_notify = false,
    configs = {
      default = require("fidget.notification").default_config,
    },
    redirect = function(msg, level, opts)
      if opts and opts.on_open then
        return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
      end
    end,
    view = {
      stack_upwards = false,
      icon_separator = " ",
      group_separator = "---",
      group_separator_hl = "Comment",
    },
    window = {
      normal_hl = "Comment",
      winblend = 0,
      border = "none",
      zindex = 45,
      max_width = 0,
      max_height = 0,
      x_padding = 1,
      y_padding = 0,
      align = "bottom",
      relative = "editor",
    },
  },
  
  progress = {
    poll_rate = 0,
    suppress_on_insert = false,
    ignore_done_already = false,
    ignore_empty_message = false,
    clear_on_detach = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client and client.name or nil
    end,
    notification_group = function(msg)
      return msg.lsp_client.name
    end,
    ignore = {},
    display = {
      render_limit = 16,
      done_ttl = 3,
      done_icon = "✔",
      done_style = "Constant",
      progress_ttl = math.huge,
      progress_icon = {
        pattern = "dots",
        period = 1,
      },
      progress_style = "WarningMsg",
      group_style = "Title",
      icon_style = "Question",
      priority = 30,
      skip_history = true,
      format_message = require("fidget.progress.display").default_format_message,
      format_annote = function(msg)
        return msg.title
      end,
      format_group_name = function(group)
        return tostring(group)
      end,
      overrides = {
        rust_analyzer = { name = "rust-analyzer" },
      },
    },
    lsp = {
      progress_ringbuf_size = 0,
      log_handler = false,
    },
  },
  
  logger = {
    level = vim.log.levels.WARN,
    float_precision = 0.01,
    path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
  },
})
```

**Files to Modify**:
- `lua/modules/lsp/lsp.lua`

---

### 7. Add Code Action Lightbulb

**Install**:
```lua
vim.pack.add({
  { src = "https://github.com/kosayoda/nvim-lightbulb" },
})
```

**Configuration**:
```lua
require("nvim-lightbulb").setup({
  priority = 10,
  hide_in_unfocused_buffer = true,
  link_highlights = true,
  validate_config = "auto",
  action_kinds = nil,
  sign = {
    enabled = true,
    text = "💡",
    hl = "DiagnosticSignWarn",
  },
  virtual_text = {
    enabled = false,
    text = "💡",
    hl = "DiagnosticVirtualTextWarn",
  },
  float = {
    enabled = false,
    text = "💡",
    hl = "DiagnosticFloatingWarn",
    win_opts = {},
  },
  status_text = {
    enabled = false,
    text = "💡",
    text_unavailable = "",
  },
  number = {
    enabled = false,
    hl = "DiagnosticSignWarn",
  },
  line = {
    enabled = false,
    hl = "CursorLine",
  },
  autocmd = {
    enabled = true,
    updatetime = 200,
    events = { "CursorHold", "CursorHoldI" },
    pattern = { "*" },
  },
  ignore = {
    clients = {},
    ft = {},
    actions_without_kind = false,
  },
})
```

**Files to Create**:
- `lua/modules/lsp/lightbulb.lua`

---

## 📋 Implementation Checklist

- [ ] Separate Mason configuration
- [ ] Auto-install all LSP servers
- [ ] Enhance Blink.cmp UI
- [ ] Improve diagnostics display
- [ ] Configure inlay hints
- [ ] Enhance Conform.nvim
- [ ] Improve Fidget.nvim
- [ ] Add code action lightbulb
- [ ] Test all language servers
- [ ] Verify formatting works

---

## 🧪 Testing Plan

1. **Mason**: `:Mason` - verify all servers installed
2. **LSP**: Open files in each language, verify completion
3. **Diagnostics**: Introduce errors, verify display
4. **Formatting**: Format files with `Space cf`
5. **Inlay Hints**: Open Rust/TS file, toggle with `Space uh`
6. **Lightbulb**: Trigger code actions, see lightbulb

---

## 📊 Success Criteria

- ✅ All LSP servers auto-install on first launch
- ✅ Completion feels VSCode-like
- ✅ Diagnostics are clear and actionable
- ✅ Formatting works for all languages
- ✅ Inlay hints visible and toggleable
- ✅ Code actions indicated with lightbulb

---

**Next Phase**: Phase 5 - UI/UX Polish
