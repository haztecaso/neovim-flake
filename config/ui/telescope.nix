{ pkgs, ... }: {
  plugins.web-devicons.enable = true;
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<M-f>" = { 
        action = "live_grep"; 
        options.desc = "live grep files";
      };
      "<C-b>" = { 
        action = "buffers"; 
        options.desc = "buffers";
      };
      "<C-p>" = { 
        action = "git_files"; 
        options.desc = "find files in current git repository";
      };
      "<M-p>" = { 
        action = "find_files"; 
        options.desc = "find files";
      };
      "<M-r>" = { 
        action = "command_history"; 
        options.desc = "command history";
      };
      "<C-e>" = { 
        action = "diagnostics"; 
        options.desc = "diagnostics";
      };
      "<leader>fh" = { action = "help_tags"; };
    };
    settings.defaults = {
      mappings.i = {
        "<C-j>".__raw = "require('telescope.actions').move_selection_next";
        "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
      };
      layout_config = {
        horizontal = {
          width_padding = 0.04;
          height_padding = 0.1;
          preview_width = 0.6;
        };
        vertical = {
          width_padding = 0.05;
          height_padding = 1;
          preview_height = 0.5;
        };
      };
      vimgrep_arguments = [
        "rg"
        "--no-heading"
        "--with-filename"
        "--line-number"
        "--column"
        "--smart-case"
      ];
    };
  };
  extraConfigLua = ''
    function live_grep_git_dir()
      local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
      git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir
      local opts = {
        cwd = git_dir,
      }
      require('telescope.builtin').live_grep(opts)
    end
  '';
  keymaps = [
    {
      key = "<C-f>";
      action = ":lua live_grep_git_dir()<CR>";
      options.desc = "live grep in current git directory";
    }
  ];
}
