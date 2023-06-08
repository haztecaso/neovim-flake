{ pkgs, ... }:
{
  startPlugins = [ pkgs.vimPlugins.ack-vim ];
  globals.ackprg = "ag --vimgrep";
  extraPackages = [ pkgs.silver-searcher ];
}
