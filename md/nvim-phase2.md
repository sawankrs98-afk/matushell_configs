# Phase 2: Core Foundation & Bootstrap

**Status**: ✅ Complete  
**Priority**: High  
**Estimated Time**: 2-3 hours

---

## 🎯 Objectives

1. Fix lspconfig deprecation warning
2. Add comprehensive error handling
3. Improve init.lua structure
4. Add health check system
5. Optimize plugin loading organization
6. Create fallback mechanisms

---

## 🔧 Tasks

### 1. Fix LSPConfig Deprecation Warning ⚠️ CRITICAL

**Problem**: 
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config 
(see :help lspconfig-nvim-0.11) instead.
Location: lua/modules/lsp/lsp.lua:370
```

**Solution**:
- Update `lua/modules/lsp/lsp.lua` to use new `vim.lsp.config` API
- Maintain backward compatibility for Neovim < 0.11
- Test all language servers still work

**Files to Modify**:
- `lua/modules/lsp/lsp.lua`

---

### 2. Improve init.lua Structure

**Current Issues**:
- Sequential loading (no error isolation)
- No startup time tracking
- No conditional loading based on environment

**Improvements**:
```lua
-- Add at top of init.lua
local start_time = vim.loop.hrtime()

-- Wrap each module in pcall
local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("Failed to load " .. module .. ": " .. err, vim.log.levels.ERROR)
  end
  return ok
end

-- Track startup time
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.loop.hrtime()
    local load_time = (end_time - start_time) / 1000000
    print(string.format("Loaded in %.2f ms", load_time))
  end
})
```

**Files to Modify**:
- `init.lua`

---

### 3. Add Comprehensive Error Handling

**Create**: `lua/core/bootstrap.lua`

**Purpose**:
- Safe module loading with error handling
- Dependency checking
- Plugin availability verification
- Graceful degradation

**Example**:
```lua
local M = {}

function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify(
      string.format("Failed to load module '%s': %s", module, result),
      vim.log.levels.ERROR
    )
    return nil
  end
  return result
end

function M.has_plugin(plugin)
  return pcall(require, plugin)
end

function M.check_dependencies()
  local deps = {
    { "telescope", "Fuzzy finder" },
    { "neo-tree", "File explorer" },
    { "blink.cmp", "Completion engine" },
  }
  
  for _, dep in ipairs(deps) do
    local name, desc = dep[1], dep[2]
    if not M.has_plugin(name) then
      vim.notify(
        string.format("%s (%s) not found", desc, name),
        vim.log.levels.WARN
      )
    end
  end
end

return M
```

**Files to Create**:
- `lua/core/bootstrap.lua`

---

### 4. Add Health Check System

**Create**: `lua/core/health.lua`

**Purpose**:
- Custom health checks for config
- Verify all critical plugins loaded
- Check for known issues
- Provide actionable fixes

**Example**:
```lua
local M = {}

function M.check()
  vim.health.start("Neovim VSCode Config")
  
  -- Check Neovim version
  local nvim_version = vim.version()
  if nvim_version.minor >= 10 then
    vim.health.ok(string.format("Neovim %s.%s.%s", nvim_version.major, nvim_version.minor, nvim_version.patch))
  else
    vim.health.error("Neovim >= 0.10.0 required")
  end
  
  -- Check critical plugins
  local plugins = {
    "telescope",
    "neo-tree", 
    "nvim-lspconfig",
    "blink.cmp",
    "nvim-treesitter",
  }
  
  for _, plugin in ipairs(plugins) do
    if pcall(require, plugin) then
      vim.health.ok(plugin .. " loaded")
    else
      vim.health.error(plugin .. " not found")
    end
  end
  
  -- Check external tools
  local tools = {
    { cmd = "git", name = "Git" },
    { cmd = "rg", name = "ripgrep" },
    { cmd = "fd", name = "fd" },
    { cmd = "lazygit", name = "lazygit" },
  }
  
  for _, tool in ipairs(tools) do
    if vim.fn.executable(tool.cmd) == 1 then
      vim.health.ok(tool.name .. " installed")
    else
      vim.health.warn(tool.name .. " not found (optional)")
    end
  end
end

return M
```

**Files to Create**:
- `lua/core/health.lua`

**Usage**: `:checkhealth core`

---

### 5. Optimize Module Loading

**Create**: `lua/core/loader.lua`

**Purpose**:
- Centralized module loading
- Load order management
- Conditional loading based on features
- Performance tracking per module

**Example**:
```lua
local M = {}

M.modules = {
  -- Core (always load first)
  core = {
    "core.options",
    "core.keymaps",
  },
  
  -- UI (load early for visual feedback)
  ui = {
    "modules.ui.themes",
    "modules.ui.alpha",
    "modules.ui.lualine",
    "modules.ui.bufferline",
    "modules.ui.indent",
  },
  
  -- Editor (load after UI)
  editor = {
    "modules.editor.neotree",
    "modules.editor.telescope",
    "modules.editor.whichkey",
  },
  
  -- LSP (defer until needed)
  lsp = {
    "modules.lsp.lsp",
    "modules.lsp.blink",
    "modules.lsp.formatting",
  },
  
  -- Optional features
  optional = {
    "modules.leetcode",
    "modules.competitive",
  },
}

function M.load_group(group)
  local modules = M.modules[group]
  if not modules then
    return
  end
  
  for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
      vim.notify(
        string.format("Failed to load %s: %s", module, err),
        vim.log.levels.WARN
      )
    end
  end
end

function M.load_all()
  M.load_group("core")
  M.load_group("ui")
  M.load_group("editor")
  M.load_group("lsp")
  
  -- Load optional only if enabled
  if vim.g.enable_leetcode ~= false then
    M.load_group("optional")
  end
end

return M
```

**Files to Create**:
- `lua/core/loader.lua`

---

### 6. Add Plugin Availability Checks

**Enhance**: All module files

**Pattern**:
```lua
-- Before
require("plugin-name").setup({})

-- After
local has_plugin, plugin = pcall(require, "plugin-name")
if has_plugin then
  plugin.setup({})
else
  vim.notify("plugin-name not available", vim.log.levels.WARN)
end
```

**Files to Modify**:
- All files in `lua/modules/*/` that configure plugins
- Priority: LSP, Editor, UI modules

---

### 7. Create Fallback Colorscheme

**Problem**: If theme fails to load, Neovim uses default

**Solution**: Add fallback mechanism

**File**: `lua/modules/ui/themes.lua`

```lua
-- At the end of themes.lua
local function set_colorscheme(name, fallback)
  local ok = pcall(vim.cmd, "colorscheme " .. name)
  if not ok and fallback then
    vim.notify(
      string.format("Failed to load colorscheme '%s', using '%s'", name, fallback),
      vim.log.levels.WARN
    )
    pcall(vim.cmd, "colorscheme " .. fallback)
  end
end

-- Set default with fallback
set_colorscheme("tokyonight", "habamax")
```

---

## 📋 Implementation Checklist

- [ ] Fix lspconfig deprecation warning
- [ ] Create `lua/core/bootstrap.lua`
- [ ] Create `lua/core/health.lua`
- [ ] Create `lua/core/loader.lua`
- [ ] Update `init.lua` with safe loading
- [ ] Add startup time tracking
- [ ] Add error handling to all modules
- [ ] Add fallback colorscheme
- [ ] Test configuration loads without errors
- [ ] Run `:checkhealth core`
- [ ] Verify startup time is reasonable (< 100ms)

---

## 🧪 Testing Plan

1. **Clean Test**:
   ```bash
   # Backup current state
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   
   # Restore phase 2 config
   # Test fresh install
   nvim --headless "+checkhealth core" +qa
   ```

2. **Error Handling Test**:
   - Temporarily rename a plugin directory
   - Launch Neovim
   - Verify graceful error message
   - Verify rest of config still loads

3. **Performance Test**:
   ```vim
   :lua print(vim.fn.printf("%.2f ms", vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time)) * 1000))
   ```

4. **Health Check Test**:
   ```vim
   :checkhealth core
   ```

---

## 📊 Success Criteria

- ✅ No deprecation warnings on startup
- ✅ All modules load with error handling
- ✅ Failed plugins don't crash config
- ✅ Startup time < 100ms (without plugin downloads)
- ✅ `:checkhealth core` shows all green/yellow (no red)
- ✅ Graceful fallback for missing plugins/themes

---

## 📝 Notes

- Keep backward compatibility with Neovim 0.9.x where possible
- Document all breaking changes
- Update CHANGELOG.md after completion
- Consider adding `vim.g.config_debug = true` flag for verbose logging

---

## 🔗 Related Files

- `init.lua` - Entry point
- `lua/modules/lsp/lsp.lua` - Critical fix needed
- `lua/modules/ui/themes.lua` - Fallback mechanism
- All plugin configuration files - Add error handling

---

**Next Phase**: Phase 3 - VSCode-like File Explorer & Navigation
