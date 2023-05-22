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
    startPlugins = [ pkgs.vimPlugins.gruvbox-nvim ];
    configRC = ''
      colorscheme gruvbox
      set background=dark
    '';
    luaConfigRC = ''
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
    '';
  };
}
