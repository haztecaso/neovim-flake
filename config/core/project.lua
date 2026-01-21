local Project = {}

-- Directories
Project.config_dir = vim.fn.expand("~/.config/nvim/projects")
Project.state_dir = vim.fn.expand("~/.local/share/nvim/project-states")
vim.fn.mkdir(Project.config_dir, "p")
vim.fn.mkdir(Project.state_dir, "p")

-- Get project info from git
function Project.get_info()
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
    if vim.v.shell_error ~= 0 then return nil end
    local name = vim.fn.fnamemodify(git_root, ":t")
    local id = vim.fn.sha256(git_root):sub(1, 16)
    return { root = git_root, name = name, id = id }
end

-- State management (JSON-based toggle persistence)
function Project.get_state_file()
    local info = Project.get_info()
    if not info then return nil end
    return Project.state_dir .. "/" .. info.id .. ".json"
end

function Project.load_state()
    local file = Project.get_state_file()
    if not file or vim.fn.filereadable(file) == 0 then return {} end
    local ok, content = pcall(vim.fn.readfile, file)
    if not ok then return {} end
    local ok2, state = pcall(vim.json.decode, table.concat(content, "\n"))
    return ok2 and state or {}
end

function Project.save_state(state)
    local file = Project.get_state_file()
    if not file then return end
    pcall(vim.fn.writefile, { vim.json.encode(state) }, file)
end

-- Config file management (full Lua configs)
function Project.get_config_file()
    local info = Project.get_info()
    if not info then return nil end
    return Project.config_dir .. "/" .. info.name .. ".lua"
end

function Project.load_config()
    local file = Project.get_config_file()
    if not file or vim.fn.filereadable(file) == 0 then return end
    local ok, err = pcall(dofile, file)
    if not ok then
        vim.notify("Project config error: " .. err, vim.log.levels.ERROR)
    end
end

-- Apply diagnostic settings based on mode
function Project.apply_diagnostic_mode(mode)
    if mode == "compact" then
        vim.diagnostic.enable(true)
        vim.diagnostic.config({ virtual_lines = false, virtual_text = { prefix = "●", spacing = 2 } })
    elseif mode == "off" then
        vim.diagnostic.enable(false)
    else -- "full" (default)
        vim.diagnostic.enable(true)
        vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
    end
end

-- Apply all saved state
function Project.apply_state()
    local state = Project.load_state()

    if state.diagnostic_mode then
        Project.apply_diagnostic_mode(state.diagnostic_mode)
    end

    if state.errors_only then
        local severity = { min = vim.diagnostic.severity.ERROR }
        vim.diagnostic.config({
            virtual_lines = { severity = severity },
            virtual_text = { severity = severity, prefix = "●" },
        })
    end

    if state.copilot ~= nil then
        vim.g.copilot_enabled = state.copilot
    end
end

-- Initialize: load config file first, then apply toggle state (state overrides config)
function Project.init()
    local info = Project.get_info()
    if not info then return end

    Project.load_config()
    Project.apply_state()

    local config_file = Project.get_config_file()
    local state = Project.load_state()
    local has_config = vim.fn.filereadable(config_file) == 1
    local has_state = next(state) ~= nil

    if has_config or has_state then
        local parts = {}
        if has_config then table.insert(parts, "config") end
        if has_state then table.insert(parts, "state") end
        vim.notify("Project: " .. info.name .. " (" .. table.concat(parts, "+") .. ")", vim.log.levels.INFO)
    end
end

-- Run on startup
Project.init()

-- Run on directory change
vim.api.nvim_create_autocmd("DirChanged", {
    callback = Project.init,
})

-- ============================================
-- Commands
-- ============================================

vim.api.nvim_create_user_command("ProjectEditConfig", function()
    local file = Project.get_config_file()
    if file then
        vim.cmd("edit " .. file)
    else
        vim.notify("Not in a git repository", vim.log.levels.WARN)
    end
end, { desc = "Edit project config file" })

vim.api.nvim_create_user_command("ProjectReload", function()
    Project.init()
    vim.notify("Project config reloaded", vim.log.levels.INFO)
end, { desc = "Reload project config and state" })

vim.api.nvim_create_user_command("ProjectClearState", function()
    local file = Project.get_state_file()
    if file and vim.fn.filereadable(file) == 1 then
        vim.fn.delete(file)
        vim.notify("Project state cleared", vim.log.levels.INFO)
    end
end, { desc = "Clear project toggle state" })

vim.api.nvim_create_user_command("ProjectInfo", function()
    local info = Project.get_info()
    if not info then
        vim.notify("Not in a git repository", vim.log.levels.WARN)
        return
    end
    local state = Project.load_state()
    local config_file = Project.get_config_file()
    local has_config = vim.fn.filereadable(config_file) == 1

    local lines = {
        "Project: " .. info.name,
        "Root: " .. info.root,
        "Config: " .. (has_config and config_file or "none"),
        "State: " .. vim.inspect(state),
    }
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show project info" })

-- ============================================
-- Keybindings for toggles
-- ============================================

-- Toggle diagnostic mode: full -> compact -> off -> full
vim.keymap.set("n", "<leader>td", function()
    local state = Project.load_state()
    local modes = { "full", "compact", "off" }
    local current = state.diagnostic_mode or "full"

    local idx = 1
    for i, m in ipairs(modes) do
        if m == current then idx = i end
    end
    local next_mode = modes[(idx % #modes) + 1]

    state.diagnostic_mode = next_mode
    state.errors_only = false -- Reset errors_only when changing mode
    Project.save_state(state)
    Project.apply_diagnostic_mode(next_mode)

    local labels = { full = "full (lsp-lines)", compact = "compact (virtual_text)", off = "off" }
    vim.notify("Diagnostics: " .. labels[next_mode])
end, { desc = "Toggle diagnostic display mode" })

-- Toggle errors-only (hide warnings/hints)
vim.keymap.set("n", "<leader>te", function()
    local state = Project.load_state()
    state.errors_only = not state.errors_only
    Project.save_state(state)

    if state.errors_only then
        local severity = { min = vim.diagnostic.severity.ERROR }
        vim.diagnostic.config({
            virtual_lines = { severity = severity },
            virtual_text = { severity = severity, prefix = "●" },
        })
        vim.notify("Diagnostics: errors only")
    else
        Project.apply_diagnostic_mode(state.diagnostic_mode or "full")
        vim.notify("Diagnostics: all severities")
    end
end, { desc = "Toggle errors-only mode" })

-- Toggle Copilot
vim.keymap.set("n", "<leader>tc", function()
    local state = Project.load_state()
    local currently_enabled = vim.g.copilot_enabled ~= false
    local new_value = not currently_enabled

    vim.g.copilot_enabled = new_value
    state.copilot = new_value
    Project.save_state(state)

    vim.notify("Copilot: " .. (new_value and "enabled" or "disabled"))
end, { desc = "Toggle Copilot" })

-- ============================================
-- Which-key registration
-- ============================================

local ok, wk = pcall(require, "which-key")
if ok then
    wk.add({
        { "<leader>t",  group = "Toggles" },
        { "<leader>td", desc = "Diagnostic mode (full/compact/off)" },
        { "<leader>te", desc = "Errors only" },
        { "<leader>tc", desc = "Copilot" },

        { "<leader>p",  group = "Project" },
        { "<leader>pe", "<cmd>ProjectEditConfig<cr>",               desc = "Edit config" },
        { "<leader>pr", "<cmd>ProjectReload<cr>",                   desc = "Reload" },
        { "<leader>pi", "<cmd>ProjectInfo<cr>",                     desc = "Info" },
        { "<leader>px", "<cmd>ProjectClearState<cr>",               desc = "Clear state" },
    })
end
