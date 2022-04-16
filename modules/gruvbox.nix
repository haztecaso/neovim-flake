{ config, lib, pkgs, ... }:
let
  cfg = config.vim.gruvbox;
in {
  options.vim.gruvbox.enable = lib.mkEnableOption "Wether to enable and config gruvbox theme";

  config = lib.mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ gruvbox ];
    vim.globals = {
      "gruvbox_contrast_dark" = "medium";
    };
    vim.configRC = ''
      colorscheme gruvbox
    '';
  };
}
