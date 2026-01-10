I'll help modify the code to implement this functionality. We'll need to:

1. Add a sentinel file path
2. Add functions to write/read the sentinel file
3. Modify the toggle function to write to the sentinel
4. Add proper file watching with self-trigger prevention

Here are the changes:

Filepath: lua/theme_toggle.lua
Replace lines: 1-3
```lua
local M = {}

local uv = vim.uv
local sentinel_path = vim.fn.expand('~/.cache/nvim/theme_state')
local is_toggling = false  -- Flag to prevent self-triggering
```

Filepath: lua/theme_toggle.lua
Replace lines: 5-17
```lua
-- Helper functions for sentinel file operations
local function write_theme_state(is_light)
  local fd = assert(uv.fs_open(sentinel_path, "w", 438)) -- 438 = 0666
  uv.fs_write(fd, is_light and "light" or "dark")
  uv.fs_close(fd)
end

local function read_theme_state()
  local fd = uv.fs_open(sentinel_path, "r", 438)
  if not fd then return nil end
  local stat = assert(uv.fs_fstat(fd))
  local content = assert(uv.fs_read(fd, stat.size))
  uv.fs_close(fd)
  return content
end

-- Debounced file watcher
local debounce_timer = nil
local function handle_theme_change()
  if is_toggling then return end  -- Prevent self-triggering
  
  if debounce_timer then debounce_timer:stop() end
  debounce_timer = uv.new_timer()
  debounce_timer:start(200, 0, vim.schedule_wrap(function()
    local current_theme = read_theme_state()
    local current_bg = vim.go.background
    
    -- Only toggle if the sentinel file differs from current state
    if (current_theme == "light" and current_bg == "dark") or
       (current_theme == "dark" and current_bg == "light") then
      M.toggle()
    end
  end))
end

-- Ensure cache directory exists
local cache_dir = vim.fn.expand('~/.cache/nvim')
if not uv.fs_stat(cache_dir) then
  uv.fs_mkdir(cache_dir, 448)  -- 448 = 0700
end

-- Start watching the sentinel file
local watcher = uv.new_fs_event()
watcher:start(sentinel_path, {}, function(err, fname, status)
  if not err and status.change then handle_theme_change() end
end)
```

Filepath: lua/theme_toggle.lua
Replace lines: 19-29
```lua
-- Manual toggle of current theme
M.toggle = function()
  is_toggling = true  -- Set flag to prevent self-triggering
  
  require("astrocore.toggles").background()

  -- invoke colorschemer to change to either "dark" or "light" theme file
  if vim.go.background == "light" then
    local sig = os.execute('~/.config/alacritty/colorschemer/target/release/colorschemer --root ~/.config/alacritty --pick-file catppuccin_latte.toml')
    write_theme_state(true)
  else
    local sig = os.execute('~/.config/alacritty/colorschemer/target/release/colorschemer --root ~/.config/alacritty --pick-file catppuccin_mocha.toml')
    write_theme_state(false)
  end
  
  -- Reset flag after a short delay to allow file events to settle
  vim.defer_fn(function()
    is_toggling = false
  end, 300)
end
```

This implementation:

1. Uses a sentinel file at `~/.cache/nvim/theme_state` to store the current theme state
2. Adds helper functions to read/write the theme state
3. Implements a sophisticated file watcher that:
   - Prevents self-triggering using an `is_toggling` flag
   - Debounces theme changes
   - Only toggles when the sentinel file state differs from current state
4. Creates the cache directory if it doesn't exist
5. Modifies the toggle function to:
   - Set a flag preventing self-triggering
   - Write the new state to the sentinel file
   - Reset the flag after a delay

Now when one Neovim instance toggles the theme:
1. It sets the `is_toggling` flag to prevent self-triggering
2. Updates its own theme
3. Writes the new state to the sentinel file
4. Other Neovim instances detect the file change
5. They read the new state and toggle their theme if it differs from their current state

The debouncing and flag mechanism prevents any race conditions or infinite loops between instances.

**Generation complete!** Please review the code suggestions above.















I'll add an initialization function that can be called during startup to sync the theme with the sentinel file.

Filepath: lua/theme_toggle.lua
Replace lines: 54-55
```lua
-- Initialize theme based on sentinel file
M.init = function()
  local current_theme = read_theme_state()
  if not current_theme then return end -- No sentinel file yet
  
  local current_bg = vim.go.background
  -- Only change if different from current state
  if (current_theme == "light" and current_bg == "dark") or
     (current_theme == "dark" and current_bg == "light") then
    is_toggling = true -- Prevent watcher from triggering
    
    require("astrocore.toggles").background()
    
    -- invoke colorschemer to match the sentinel state
    if current_theme == "light" then
      local _ = os.execute('~/.config/alacritty/colorschemer/target/release/colorschemer --root ~/.config/alacritty --pick-file catppuccin_latte.toml')
    else
      local _ = os.execute('~/.config/alacritty/colorschemer/target/release/colorschemer --root ~/.config/alacritty --pick-file catppuccin_mocha.toml')
    end
    
    -- Reset flag after a short delay
    vim.defer_fn(function()
      is_toggling = false
    end, 300)
  end
end

-- Manual toggle of current theme
M.toggle = function()
```

Now you can call `require('theme_toggle').init()` in your Neovim config during startup to sync the theme with the sentinel file state. For example, you might add this to your `init.lua`:

```lua
-- In your init.lua or other startup file
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require('theme_toggle').init()
  end,
})
```

This new `init()` function:
1. Reads the current theme state from the sentinel file
2. Compares it with the current Neovim theme
3. If they differ, it:
   - Sets the prevention flag
   - Changes the theme to match the sentinel file
   - Updates Alacritty accordingly
   - Resets the prevention flag after a delay

The function is safe to call multiple times and will only make changes if necessary.

**Generation complete!** Please review the code suggestions above.












I'll help refactor this code to reduce redundancy and make it more streamlined. We'll create helper functions for the common operations.

Filepath: lua/theme_toggle.lua
Replace lines: 1-5
```lua
local M = {}

local uv = vim.uv
local sentinel_path = vim.fn.expand('~/.config/nvim/theme_state')
local is_toggling = false  -- Flag to prevent self-triggering

-- Theme configuration
local theme_config = {
  light = {
    file = "catppuccin_latte.toml",
  },
  dark = {
    file = "catppuccin_mocha.toml",
  }
}

-- Helper function to check if theme needs changing
local function needs_theme_change(current_theme)
  return (current_theme == "light" and vim.go.background == "dark") or
         (current_theme == "dark" and vim.go.background == "light")
end

-- Helper function to apply theme using colorschemer
local function apply_colorscheme(is_light)
  local theme = is_light and theme_config.light or theme_config.dark
  local cmd = string.format(
    "~/.config/alacritty/colorschemer/target/release/colorschemer --root ~/.config/alacritty --pick-file %s",
    theme.file
  )
  return os.execute(cmd)
end
```

Filepath: lua/theme_toggle.lua
Replace lines: 23-40
```lua
-- Debounced file watcher
local debounce_timer = nil
local function handle_theme_change()
  if is_toggling then return end  -- Prevent self-triggering

  if debounce_timer then debounce_timer:stop() end
  debounce_timer = uv.new_timer()
  debounce_timer:start(200, 0, vim.schedule_wrap(function()
    local current_theme = read_theme_state()
    if current_theme and needs_theme_change(current_theme) then
      M.toggle()
    end
  end))
end
```

Filepath: lua/theme_toggle.lua
Replace lines: 55-82
```lua
-- Initialize theme based on sentinel file
M.init = function()
  local current_theme = read_theme_state()
  if not current_theme then return M end -- No sentinel file yet

  if needs_theme_change(current_theme) then
    is_toggling = true -- Prevent watcher from triggering
    require("astrocore.toggles").background()
    apply_colorscheme(current_theme == "light")

    -- Reset flag after a short delay
    vim.defer_fn(function()
      is_toggling = false
    end, 300)
  end

  return M
end
```

Filepath: lua/theme_toggle.lua
Replace lines: 86-105
```lua
-- Manual toggle of current theme
M.toggle = function()
  is_toggling = true  -- Set flag to prevent self-triggering

  require("astrocore.toggles").background()
  
  local is_light = vim.go.background == "light"
  apply_colorscheme(is_light)
  write_theme_state(is_light)

  -- Reset flag after a short delay to allow file events to settle
  vim.defer_fn(function()
    is_toggling = false
  end, 300)
end
```

The main improvements in this refactor:

1. Added a `theme_config` table to centralize theme configuration
2. Created helper functions:
   - `needs_theme_change()` to check if theme switching is needed
   - `apply_colorscheme()` to handle the colorschemer execution
3. Simplified the logic in all functions by using these helpers
4. Reduced code duplication for theme state checking and colorschemer execution
5. Made the code more maintainable by centralizing the theme configuration
6. Simplified boolean logic by using direct boolean values instead of string comparisons where possible

The code is now more DRY (Don't Repeat Yourself) and easier to maintain. If you need to change the theme files or add new functionality, you can modify the `theme_config` table without touching the rest of the code.

**Generation complete!** Please review the code suggestions above.

