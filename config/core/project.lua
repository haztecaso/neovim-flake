--- Project-local configuration and state management for Neovim.
--- Provides per-project settings persistence using git repository identification,
--- with fallback to per-file state for non-git files.
---
--- Features:
--- - Project identification via UUID stored in .git/config
--- - Per-project Lua config files (~/.config/nvim/projects/<uuid>.lua)
--- - Per-project state persistence (~/.local/share/nvim/project-states/<uuid>.json)
--- - Per-file state fallback for non-git files
--- - Extensible toggle registration system
---
---@class ProjectModule
---@field CONFIG_DIR string Directory for project config files
---@field STATE_DIR string Directory for project state files
---@field FILE_STATE_DIR string Directory for per-file state files
---@field toggles table<string, ToggleConfig> Registry of all toggles
Project = {}

-- ============================================
-- Constants
-- ============================================

Project.CONFIG_DIR = vim.fn.expand("~/.config/nvim/projects")
Project.STATE_DIR = vim.fn.expand("~/.local/share/nvim/project-states")
Project.FILE_STATE_DIR = vim.fn.expand("~/.local/share/nvim/file-states")

vim.fn.mkdir(Project.CONFIG_DIR, "p")
vim.fn.mkdir(Project.STATE_DIR, "p")
vim.fn.mkdir(Project.FILE_STATE_DIR, "p")

-- ============================================
-- Toggle Registry
-- ============================================

---@class ToggleConfig
---@field key string Keybinding
---@field desc string Description
---@field modes? string[] List of modes (nil for boolean)
---@field labels? table<string, string> Mode labels
---@field default? string Default mode
---@field apply fun(mode: string|boolean) Function to apply setting

--- Registry of all toggles
---@type table<string, ToggleConfig>
Project.toggles = {}

-- ============================================
-- Private helpers
-- ============================================

--- Generate a UUID v4 using random numbers.
---@return string uuid The generated UUID
local function generate_uuid()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
        return string.format("%x", v)
    end)
end

--- Hash a file path for use as a state file identifier.
---@param path string The file path to hash
---@return string hash First 16 characters of SHA256 hash
local function hash_path(path)
    return vim.fn.sha256(path):sub(1, 16)
end

--- Get or create a project UUID from .git/config.
---@param git_root string The git repository root path
---@return string uuid The project UUID
local function get_or_create_uuid(git_root)
    local cmd = "git -C " .. vim.fn.shellescape(git_root) .. " config --local --get nvim-project.id 2>/dev/null"
    local uuid = vim.fn.system(cmd):gsub("\n", "")

    if vim.v.shell_error ~= 0 or uuid == "" then
        uuid = generate_uuid()
        vim.fn.system("git -C " .. vim.fn.shellescape(git_root) .. " config --local nvim-project.id " .. uuid)
        vim.notify("Project: generated new ID", vim.log.levels.DEBUG)
    end

    return uuid
end

-- ============================================
-- Public API
-- ============================================

--- Check if the current directory is inside a git repository.
---@return boolean is_git True if in a git repository
function Project.is_in_git_repo()
    vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
    return vim.v.shell_error == 0
end

---@class ProjectInfo
---@field root string Git repository root path
---@field name string Project name (directory basename)
---@field id string Project UUID

--- Get project information from git.
---@return ProjectInfo|nil info Project info or nil if not in a git repo
function Project.get_info()
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
    if vim.v.shell_error ~= 0 then
        return nil
    end

    local name = vim.fn.fnamemodify(git_root, ":t")
    local uuid = get_or_create_uuid(git_root)

    return { root = git_root, name = name, id = uuid }
end

--- Get the state file path for the current project or file.
--- For git repos, uses project UUID. For non-git files, uses hashed file path.
---@return string|nil path State file path or nil if no file is open
function Project.get_state_file()
    local info = Project.get_info()
    if info then
        return Project.STATE_DIR .. "/" .. info.id .. ".json"
    end

    local current_file = vim.fn.expand("%:p")
    if current_file == "" then
        return nil
    end
    return Project.FILE_STATE_DIR .. "/" .. hash_path(current_file) .. ".json"
end

---@class ProjectState
---@field [string] any Toggle states keyed by toggle name

--- Load the saved state for the current project or file.
---@return ProjectState state The loaded state (empty table if none)
function Project.load_state()
    local file = Project.get_state_file()
    if not file or vim.fn.filereadable(file) == 0 then
        return {}
    end

    local ok, content = pcall(vim.fn.readfile, file)
    if not ok then
        return {}
    end

    local ok2, state = pcall(vim.json.decode, table.concat(content, "\n"))
    return ok2 and state or {}
end

--- Save state for the current project or file.
---@param state ProjectState The state to save
function Project.save_state(state)
    local file = Project.get_state_file()
    if not file then
        return
    end
    pcall(vim.fn.writefile, { vim.json.encode(state) }, file)
end

--- Get the config file path for the current project.
--- Config files are only available for git repositories.
---@return string|nil path Config file path or nil if not in a git repo
function Project.get_config_file()
    local info = Project.get_info()
    if not info then
        return nil
    end
    return Project.CONFIG_DIR .. "/" .. info.id .. ".lua"
end

--- Load and execute the project config file if it exists.
function Project.load_config()
    local file = Project.get_config_file()
    if not file or vim.fn.filereadable(file) == 0 then
        return
    end

    local ok, err = pcall(dofile, file)
    if not ok then
        vim.notify("Project config error: " .. err, vim.log.levels.ERROR)
    end
end

--- Apply a specific toggle setting.
---@param name string Toggle name
---@param value string|boolean The value to apply
function Project.apply_toggle(name, value)
    local toggle = Project.toggles[name]
    if toggle and toggle.apply then
        toggle.apply(value)
    end
end

--- Apply all saved state settings using registered toggles.
function Project.apply_state()
    local state = Project.load_state()

    for name, toggle in pairs(Project.toggles) do
        local value = state[name]
        if value ~= nil then
            toggle.apply(value)
        elseif toggle.default then
            -- Apply default if no state saved
            if toggle.modes then
                toggle.apply(toggle.default)
            else
                -- Boolean toggle: parse "true"/"false" string
                toggle.apply(toggle.default == "true")
            end
        end
    end
end

--- Register a new toggle.
---@param name string Toggle identifier (used in state persistence)
---@param config ToggleConfig Toggle configuration
function Project.register_toggle(name, config)
    Project.toggles[name] = config

    -- Create <Plug> mapping
    local plug_name = "<Plug>(ProjectToggle" .. name:gsub("^%l", string.upper):gsub("_(%l)", function(c)
        return c:upper()
    end) .. ")"

    vim.keymap.set("n", plug_name, function()
        local state = Project.load_state()

        if config.modes then
            -- Multi-mode toggle: cycle through modes
            local current = state[name] or config.default or config.modes[1]
            local idx = 1
            for i, mode in ipairs(config.modes) do
                if mode == current then
                    idx = i
                    break
                end
            end
            local next_mode = config.modes[(idx % #config.modes) + 1]

            state[name] = next_mode
            Project.save_state(state)
            config.apply(next_mode)

            local label = config.labels and config.labels[next_mode] or next_mode
            vim.notify(config.desc:gsub(" %b()", "") .. ": " .. label)
        else
            -- Boolean toggle
            local current = state[name]
            if current == nil then
                current = config.default == "true"
            end
            local new_value = not current

            state[name] = new_value
            Project.save_state(state)
            config.apply(new_value)

            vim.notify(config.desc .. ": " .. (new_value and "enabled" or "disabled"))
        end
    end, { desc = config.desc })

    -- Create default keybinding
    vim.keymap.set("n", config.key, plug_name)

    -- Register with which-key
    local ok, wk = pcall(require, "which-key")
    if ok then
        wk.add({
            { config.key, desc = config.desc },
        })
    end
end

--- Initialize the project module.
--- Loads config file first, then applies toggle state (state overrides config).
function Project.init()
    local info = Project.get_info()

    if info then
        Project.load_config()
        Project.apply_state()

        local config_file = Project.get_config_file()
        local state = Project.load_state()
        local has_config = config_file and vim.fn.filereadable(config_file) == 1
        local has_state = next(state) ~= nil

        if has_config or has_state then
            local parts = {}
            if has_config then
                table.insert(parts, "config")
            end
            if has_state then
                table.insert(parts, "state")
            end
            vim.notify("Project: " .. info.name .. " (" .. table.concat(parts, "+") .. ")", vim.log.levels.INFO)
        end
    else
        local state = Project.load_state()
        if next(state) ~= nil then
            Project.apply_state()
            local current_file = vim.fn.expand("%:t")
            if current_file ~= "" then
                vim.notify("File state: " .. current_file, vim.log.levels.DEBUG)
            end
        end
    end
end

-- ============================================
-- Commands (scoped under :Project)
-- ============================================

---@type table<string, {impl: fun(args: string[]), complete?: fun(lead: string): string[], desc: string}>
local subcommands = {
    edit = {
        impl = function(_)
            local file = Project.get_config_file()
            if file then
                vim.cmd("edit " .. file)
            else
                vim.notify(
                    "Project configs require a git repository (state toggles still work for individual files)",
                    vim.log.levels.WARN
                )
            end
        end,
        desc = "Edit project config file",
    },
    reload = {
        impl = function(_)
            Project.init()
            vim.notify("Project config reloaded", vim.log.levels.INFO)
        end,
        desc = "Reload project config and state",
    },
    clear = {
        impl = function(_)
            local file = Project.get_state_file()
            if file and vim.fn.filereadable(file) == 1 then
                vim.fn.delete(file)
                local info = Project.get_info()
                if info then
                    vim.notify("Cleared state for project: " .. info.name, vim.log.levels.INFO)
                else
                    vim.notify("Cleared state for current file", vim.log.levels.INFO)
                end
            else
                vim.notify("No saved state to clear", vim.log.levels.INFO)
            end
        end,
        desc = "Clear project toggle state",
    },
    info = {
        impl = function(_)
            local info = Project.get_info()
            local state = Project.load_state()
            local state_file = Project.get_state_file()

            -- Build toggles info with current values
            local toggle_names = {}
            for name, _ in pairs(Project.toggles) do
                table.insert(toggle_names, name)
            end
            table.sort(toggle_names)

            local function format_toggle_value(name, toggle)
                local value = state[name]
                if toggle.modes then
                    -- Multi-mode toggle
                    local current = value or toggle.default or toggle.modes[1]
                    local label = toggle.labels and toggle.labels[current] or current
                    return label
                else
                    -- Boolean toggle
                    local current = value
                    if current == nil then
                        current = toggle.default == "true"
                    end
                    return current and "on" or "off"
                end
            end

            local function format_toggles_section()
                if #toggle_names == 0 then
                    return { "  (none registered)" }
                end
                local lines = {}
                for _, name in ipairs(toggle_names) do
                    local toggle = Project.toggles[name]
                    local value = format_toggle_value(name, toggle)
                    local saved = state[name] ~= nil and "*" or " "
                    table.insert(lines, string.format("  %s %-14s %s  [%s]", saved, name, toggle.key, value))
                end
                return lines
            end

            local lines = {}

            if info then
                local config_file = Project.get_config_file()
                local has_config = config_file and vim.fn.filereadable(config_file) == 1

                table.insert(lines, "Project: " .. info.name)
                table.insert(lines, "Root:    " .. info.root)
                table.insert(lines, "ID:      " .. info.id)
                table.insert(lines, "")
                table.insert(lines, "Config:  " .. (has_config and config_file or "(none)"))
                table.insert(lines, "State:   " .. (state_file or "(none)"))
                table.insert(lines, "")
                table.insert(lines, "Toggles: (* = saved)")
                vim.list_extend(lines, format_toggles_section())
            else
                local current_file = vim.fn.expand("%:p")
                table.insert(lines, "Mode: Per-file (no git repository)")
                table.insert(lines, "File: " .. (current_file ~= "" and current_file or "(no file)"))
                table.insert(lines, "")
                table.insert(lines, "State: " .. (state_file or "(none)"))
                table.insert(lines, "")
                table.insert(lines, "Toggles: (* = saved)")
                vim.list_extend(lines, format_toggles_section())
                table.insert(lines, "")
                table.insert(lines, "Note: Project configs require a git repository")
            end

            vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
        end,
        desc = "Show project info",
    },
}

vim.api.nvim_create_user_command("Project", function(opts)
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local subcmd_name = args[1]

    if not subcmd_name then
        vim.notify("Usage: :Project <edit|reload|clear|info>", vim.log.levels.WARN)
        return
    end

    local subcmd = subcommands[subcmd_name]
    if not subcmd then
        vim.notify("Unknown subcommand: " .. subcmd_name, vim.log.levels.ERROR)
        return
    end

    table.remove(args, 1)
    subcmd.impl(args)
end, {
    nargs = "+",
    desc = "Project configuration management",
    complete = function(arg_lead, cmdline, _)
        local subcmd_names = vim.tbl_keys(subcommands)
        local parts = vim.split(cmdline, "%s+", { trimempty = true })

        if #parts == 1 or (#parts == 2 and not cmdline:match("%s$")) then
            return vim.iter(subcmd_names)
                :filter(function(name)
                    return name:find(arg_lead, 1, true) == 1
                end)
                :totable()
        end

        local subcmd = subcommands[parts[2]]
        if subcmd and subcmd.complete then
            return subcmd.complete(arg_lead)
        end

        return {}
    end,
})

-- ============================================
-- Autocommands
-- ============================================

vim.api.nvim_create_autocmd("DirChanged", {
    callback = Project.init,
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if not Project.is_in_git_repo() then
            local state = Project.load_state()
            if next(state) ~= nil then
                Project.apply_state()
            end
        end
    end,
})

-- ============================================
-- Which-key base groups
-- ============================================

local ok, wk = pcall(require, "which-key")
if ok then
    wk.add({
        { "<leader>t",  group = "Toggles" },
        { "<leader>p",  group = "Project" },
        { "<leader>pe", "<cmd>Project edit<cr>",   desc = "Edit config" },
        { "<leader>pr", "<cmd>Project reload<cr>", desc = "Reload" },
        { "<leader>pi", "<cmd>Project info<cr>",   desc = "Info" },
        { "<leader>px", "<cmd>Project clear<cr>",  desc = "Clear state" },
    })
end

-- Note: Project.init() will be called after all toggles are registered
-- via vim.schedule in the toggle registration, or manually if needed
