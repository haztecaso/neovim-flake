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
    startPlugins = with pkgs.vimPlugins;  filterNonNull [
      ultisnips
      (if config.completion.enable then cmp-nvim-ultisnips else null)
      vim-snippets
    ];
    globals = {
      "UltiSnipsExpandTrigger" = "<tab>";
      "UltiSnipsJumpForwardTrigger" = "<tab>";
      "UltiSnipsJumpBackwardTrigger" = "<s-tab>";
      "UltiSnipsSnippetDirectories" = [ 
        "UltiSnips" 
        "~/src/neovim-flake/snippets/" 
        "${../snippets}" 
      ];
    };
  };
}
