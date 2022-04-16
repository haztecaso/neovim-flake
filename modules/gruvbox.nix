{ config, lib, pkgs, ... }:
let
  cfg = config.gruvbox;
in {
  options.gruvbox.enable = lib.mkEnableOption "Wether to enable and config gruvbox theme";

  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [ gruvbox ];
    globals = {
      "gruvbox_contrast_dark" = "medium";
    };
    configRC = ''
      colorscheme gruvbox
    '';
  };
}
