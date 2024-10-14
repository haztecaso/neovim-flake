{ pkgs, ... }: {
  extraPlugins = [ pkgs.vimPlugins.vim-vinegar ];
  globals = {
    "netrw_liststyle" = 3;
    "netrw_banner" = 0;
  };
}
