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
    if current_theme and needs_theme_change(current_theme) then
      M.toggle()
    end
  end))
end

-- Ensure cache directory exists
-- local cache_dir = vim.fn.expand('~/.config/nvim')
-- if not uv.fs_stat(cache_dir) then
--   uv.fs_mkdir(cache_dir, 448)  -- 448 = 0700
-- end

-- Start watching the sentinel file
local watcher = uv.new_fs_event()
local ok = watcher:start(sentinel_path, {}, function(err, fname, status)
  if not err and status.change then handle_theme_change() end
end)

if not ok then
  vim.notify(
    string.format("Failed to start theme state file watcher for: %s", sentinel_path),
    vim.log.levels.WARN
  )
  watcher:close()
end

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

return M
