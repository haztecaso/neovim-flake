{ pkgs, ... }:
{
  startPlugins = [ pkgs.vimPlugins.vim-fugitive ];

  nmap = {
    "<leader>gg" = ":call FugitiveToggle()<CR>";
    "<leader>gd" = ":Gdiff<CR>";
    "<leader>gD" = ":call MyCloseDiff()<CR>";
  };
}
