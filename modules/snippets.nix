{ config, lib, pkgs, ... }:
let
  cfg = config.snippets;
  filterNonNull = builtins.filter (x: x != null);
in {
  options.snippets = with lib; {
    enable = mkEnableOption "Wether to enable snippets (ultisnips)";
  };
  config = lib.mkIf config.completion.enable {
    startPlugins = with pkgs; filterNonNull [ 
      vimPlugins.ultisnips
      (if cfg.completion.enable then neovimPlugins.cmp-nvim-ultisnips else null)
    ];
  };
}
