{ config, lib, pkgs, ... }:
let
  cfg = config.completion;
in
{
  options.telescope = with lib; {
    enable = mkEnableOption "Wether to enable telescope and plugins";
  };
  config = lib.mkIf cfg.enable {
    luaConfigRC = ''
      local telescope_builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
    '';
  };
}
