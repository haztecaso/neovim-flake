{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.ack-vim ];
  extraPackages = [ pkgs.ripgrep ];
  globals.ackprg = "rg --vimgrep";
}
