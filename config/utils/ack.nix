{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.ack-vim ];
  extraPackages = [ pkgs.silver-searcher ];
  globals.ackprg = "ag --vimgrep";
}
