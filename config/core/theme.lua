-- Desktop theme integration. See config/core/theme.nix.
local Theme = {}

local state_dir = (os.getenv("XDG_STATE_HOME") or (vim.env.HOME .. "/.local/state")) .. "/theme"
local palette_path = state_dir .. "/current/palette.lua"

-- Returns false when there is no usable palette.
local function apply_palette()
  if vim.fn.filereadable(palette_path) == 0 then
    return false
  end
  local ok, t = pcall(dofile, palette_path)
  if not ok or type(t) ~= "table" or type(t.palette) ~= "table" then
    return false
  end
  -- Set background before mini.base16: it clears g:colors_name, and changing
  -- 'background' with g:colors_name set reloads that colorscheme.
  ok = pcall(function()
    vim.o.background = t.polarity == "light" and "light" or "dark"
    require("mini.base16").setup({ palette = t.palette, use_cterm = true })
  end)
  if not ok then
    return false
  end
  vim.g.theme_name = t.name
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = t.name, modeline = false })
  return true
end

local function apply_fallback(scheme)
  vim.g.theme_name = nil
  vim.o.background = scheme == 2 and "light" or "dark"
  pcall(vim.cmd.colorscheme, "gruvbox")
end

-- Calls cb with the portal color-scheme: 0 none, 1 dark, 2 light.
local function read_portal(cb)
  if vim.fn.executable("gdbus") == 0 then
    return cb(0)
  end
  vim.system({
    "gdbus", "call", "--session",
    "--dest", "org.freedesktop.portal.Desktop",
    "--object-path", "/org/freedesktop/portal/desktop",
    "--method", "org.freedesktop.portal.Settings.ReadOne",
    "org.freedesktop.appearance", "color-scheme",
  }, { text = true }, function(res)
    local v = res.code == 0 and tonumber((res.stdout or ""):match("uint32 (%d)")) or 0
    vim.schedule(function()
      cb(v)
    end)
  end)
end

function Theme.apply()
  if not apply_palette() then
    read_portal(apply_fallback)
  end
end

-- Short debounce: one theme switch touches several files in the state dir.
local timer = vim.uv.new_timer()
local function schedule_apply()
  timer:stop()
  timer:start(30, 0, vim.schedule_wrap(Theme.apply))
end

local function watch_state()
  if vim.fn.isdirectory(state_dir) == 0 then
    return
  end
  local w = vim.uv.new_fs_event()
  w:start(state_dir, {}, function(err, fname)
    if not err and fname == "current" then
      schedule_apply()
    end
  end)
end

local function watch_portal()
  if vim.fn.executable("gdbus") == 0 then
    return
  end
  vim.fn.jobstart({
    "gdbus", "monitor", "--session",
    "--dest", "org.freedesktop.portal.Desktop",
    "--object-path", "/org/freedesktop/portal/desktop",
  }, {
    on_stdout = function(_, lines)
      for _, l in ipairs(lines) do
        -- With a palette the state-dir watcher already covers switches;
        -- reacting here too would apply every switch twice.
        if l:find("color-scheme", 1, true) and vim.fn.filereadable(palette_path) == 0 then
          schedule_apply()
          return
        end
      end
    end,
  })
end

Theme.apply()
watch_state()
watch_portal()
