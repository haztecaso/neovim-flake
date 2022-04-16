{ config, lib, pkgs, ... }:
let
  cfg = config.gruvbox;
in
{
  options.gruvbox.enable = with lib; mkOption {
    type = types.bool;
    description = "Wether to enable and config gruvbox theme";
    default = true;
  };

  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs.vimPlugins; [ gruvbox ];
    globals = {
      "gruvbox_contrast_dark" = "hard";
    };
    configRC = ''
      colorscheme gruvbox
      set bg=dark
    '';
  };
}
