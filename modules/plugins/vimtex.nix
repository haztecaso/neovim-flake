{ pkgs, ... }: {
  startPlugins = [ pkgs.vimPlugins.vimtex ];
  globals = {
    "tex_flavor" = "latex";
    "vimtex_view_method" = "zathura";
    "vimtex_quickfix_mode" = 1;
    "vimtex_imaps_leader" = "ç";
    "vimtex_quickfix_autoclose_after_keystrokes" = 1;
    "vimtex_quickfix_open_on_warning" = 0;
  };
}
