{ config, lib, pkgs, ... }:
let
  cfg = config.completion;
in
{
  options.telescope = with lib; {
    enable = mkEnableOption "Wether to enable telescope and plugins";
  };
  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs; [
      vimPlugins.plenary-nvim 
      vimPlugins.telescope-nvim
      vimPlugins.telescope-fzf-native-nvim
      neovimPlugins.nvim-neoclip
      neovimPlugins.telescope-repo
    ];
    plugins.ctrlp = false;
    luaConfigRC = ''
      require'telescope'.load_extension'neoclip'
      -- TODO: Instalar binario fd
      require'telescope'.load_extension'repo'
      require'telescope'.load_extension'fzf'

      local telescope_builtins = require('telescope.builtin')
      local telescope_extensions = require('telescope').extensions

      -- TODO: Instalar binario repgrip
      vim.keymap.set('n', '<C-f>', telescope_builtins.live_grep, {}) 
      vim.keymap.set('n', '<C-b>', telescope_builtins.buffers, {}) 
      vim.keymap.set('n', '<C-p>', telescope_builtins.git_files, {}) 
      vim.keymap.set('n', '<C-b>', telescope_builtins.buffers, {}) 
      vim.keymap.set('n', '<C-y>', telescope_extensions.neoclip.default, {}) 
      vim.keymap.set('n', '<M-p>', telescope_builtins.find_files, {}) 
      vim.keymap.set('n', '<M-r>', telescope_builtins.command_history, {}) 
      vim.keymap.set('n', '<C-e>', telescope_builtins.diagnostics, {}) 

      vim.keymap.set('n', '<C-h>', telescope_builtins.help_tags, {}) 
      vim.keymap.set('n', '<leader>fh', telescope_builtins.help_tags, {})

      local telescope_actions = require('telescope.actions')

      require('telescope').setup{
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<C-j>"] = telescope_actions.move_selection_next,
              ["<C-k>"] = telescope_actions.move_selection_previous,
            }
          },
          layout_config = {
            horizontal = {
              width_padding = 0.04,
              height_padding = 0.1,
              preview_width = 0.6,
            },
            vertical = {
              width_padding = 0.05,
              height_padding = 1,
              preview_height = 0.5,
            },
          },
        }
      }

      require('neoclip').setup()
        
    '';
  };
}
