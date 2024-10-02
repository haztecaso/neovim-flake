{ pkgs, ... }: {
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<C-f>" = { action = "live_grep"; };
      "<C-b>" = { action = "buffers"; };
      "<C-p>" = { action = "git_files"; };
      "<C-y>" = { action = "neoclip.default"; };
      "<M-p>" = { action = "find_files"; };
      "<M-r>" = { action = "command_history"; };
      "<C-e>" = { action = "diagnostics"; };
      "<leader>fh" = { action = "help_tags"; };
    };
    settings.defaults = {
      mappings.i = {
        "<C-j>".__raw = "require('telescope.actions').move_selection_next";
        "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
      };
    };
  };
  plugins.web-devicons.enable = true;
}
