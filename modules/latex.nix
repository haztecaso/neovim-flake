{ config, lib, pkgs, ... }:
{
  options.vim.languages.latex = with lib; {
    enable = mkEnableOption "Enable latex plugin";
  };
    config = lib.mkIf cfg.enable {
      vim = {
        optPlugins = with pkgs.vimPlugins; [ vimtex ];
        configRC = ''
          let g:tex_flavor='latex'
          let g:vimtex_view_method = 'zathura'
          let g:vimtex_quickfix_mode=1
          let g:vimtex_quickfix_open_on_warning = 0
          let g:vimtex_imaps_leader = 'ñ'
          set conceallevel=1
          " let g:tex_conceal='abmg'
          autocmd FileType tex :packadd vimtex
        '';
      };
  };
}
