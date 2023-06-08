{ pkgs, ... }:
{
  startPlugins = [ pkgs.vimPlugins.vim-gitgutter ];
  globals = {
    "gitgutter_sign_added" = "+";
    "gitgutter_sign_modified" = "~";
    "gitgutter_sign_removed" = "_";
    "gitgutter_sign_removed_first_line" = "‾";
    "gitgutter_sign_removed_above_and_below" = "_¯";
    "gitgutter_sign_modified_removed" = "~_";
  };
}
