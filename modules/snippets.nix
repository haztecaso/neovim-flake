{ config, lib, pkgs, ... }:
let
  cfg = config.snippets;
in
{
  options.snippets = with lib; {
    enable = mkEnableOption "Wether to enable snippets (ultisnips)";
  };
  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs.vimPlugins; [ ultisnips vim-snippets ];
    globals = {
      "UltiSnipsExpandTrigger" = "<c-j>";
      "UltiSnipsJumpForwardTrigger" = "<c-j>";
      "UltiSnipsJumpBackwardTrigger" = "<s-tab>";
      "UltiSnipsSnippetDirectories" = [
        "UltiSnips"
        "~/src/neovim-flake/snippets/"
        "${../snippets}"
      ];
    };
  };
}
