{ pkgs, ... }:
{
  startPlugins = with pkgs; [
    vimPlugins.plenary-nvim
    vimPlugins.telescope-nvim
    vimPlugins.telescope-fzf-native-nvim
    neovimPlugins.nvim-neoclip
    neovimPlugins.telescope-repo
  ];
  extraPackages = [ pkgs.ripgrep pkgs.fd ];
}
