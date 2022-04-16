{ config, lib, pkgs, ... }:
let
  cfg = config.snippets;
  filterNonNull = builtins.filter (x: x != null);
in
{
  options.snippets = with lib; {
    enable = mkEnableOption "Wether to enable snippets (ultisnips)";
  };
  config = lib.mkIf config.completion.enable {
    startPlugins = with pkgs.vimPlugins; filterNonNull [
      vim-vsnip
      (if config.completion.enable then cmp-vsnip else null)
      vim-snippets
    ];
  };
}
