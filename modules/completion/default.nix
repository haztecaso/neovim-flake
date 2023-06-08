{ config, lib, pkgs, ... }:
let
  cfg = config.completion;
in
{
  options.completion = with lib; {
    enable = mkEnableOption "Wether to enable nvim-cmp";
  };
  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-cmdline
      cmp-path
      cmp-latex-symbols
      cmp-nvim-ultisnips
      nvim-cmp
    ];

    # Completion support currently depends on snippets being enabled
    snippets.enable = true;

    luaConfigRC = builtins.readFile ./config.lua;
  };
}
