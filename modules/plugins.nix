{ config, lib, pkgs, ... }:
let
  cfg = config.plugins;
  configs = {
    ack = {
      startPlugins = [ pkgs.vimPlugins.ack-vim ];
      globals.ackprg = "${pkgs.silver-searcher}/bin/ag --vimgrep";
    };
    commentary.startPlugins = [ pkgs.vimPlugins.vim-commentary ];
    ctrlp = {
      startPlugins = [ pkgs.vimPlugins.ctrlp ];
      globals."ctrlp_show_hidden" = "1";
      globals."ctrlp_custom_ignore" = ".git\|node_modules";
    };
    git = {
      startPlugins = with pkgs.vimPlugins; [ vim-fugitive vim-gitgutter ];
      globals = {
        "gitgutter_sign_added" = "+";
        "gitgutter_sign_modified" = "~";
        "gitgutter_sign_removed" = "_";
        "gitgutter_sign_removed_first_line" = "‾";
        "gitgutter_sign_removed_above_and_below" = "_¯";
        "gitgutter_sign_modified_removed" = "~_";
      };
      configRC = ''
		function FugitiveToggle() abort
		  try
		    exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
		  catch /E684/
		    vertical Git
		    vertical resize 80
		  endtry
		endfunction

        " vimdiff current vs git head (fugitive extension) {{{2
        nnoremap <Leader>gd :Gdiff<cr>
        " Close any corresponding diff buffer
        function! MyCloseDiff()
          if (&diff == 0 || getbufvar('#', '&diff') == 0)
                \ && (bufname('%') !~ '^fugitive:' && bufname('#') !~ '^fugitive:')
            echom "Not in diff view."
            return
          endif
        
          " close current buffer if alternate is not fugitive but current one is
          if bufname('#') !~ '^fugitive:' && bufname('%') =~ '^fugitive:'
            if bufwinnr("#") == -1
              b #
              bd #
            else
              bd
            endif
          else
            bd # 
          endif
        endfunction
      '';

      nmap = {
        "<leader>gg" = ":call FugitiveToggle()<CR>";
        "<leader>gd" = ":Gdiff<CR>";
        "<leader>gD" = ":call MyCloseDiff()<CR>";
      };
    };
    lastplace.startPlugins = [ pkgs.vimPlugins.vim-lastplace ];
    latex = {
      startPlugins = [ pkgs.vimPlugins.vimtex ];
      globals = {
        "tex_flavor" = "latex";
        "vimtex_view_method" = "zathura";
        "vimtex_quickfix_mode" = 1;
        "vimtex_quickfix_open_on_warning" = 0;
      };
    };
    nix.startPlugins = [ pkgs.vimPlugins.vim-nix ];
    nvim-which-key.startPlugins = [ pkgs.neovimPlugins.nvim-which-key ];
    vinegar = {
      startPlugins = [ pkgs.vimPlugins.vim-vinegar ];
      globals = {
        "netrw_liststyle" = "3";
        "netrw_banner" = "0";
      };
    };
  };
in
{
  options.plugins =
    let
      mkBoolOption = description: lib.mkOption {
        inherit description;
        type = lib.types.bool;
      };
    in
    {
      ack = mkBoolOption "Enable ack support.";
      commentary = mkBoolOption "Enable vim-commentary.";
      ctrlp = mkBoolOption "Enable ctrlp plugin.";
      git = mkBoolOption "Enable git support.";
      lastplace = mkBoolOption "Enable vim-lastplace.";
      latex = mkBoolOption "Enable latex support.";
      nix = mkBoolOption "Enable vim-nix.";
      nvim-which-key = mkBoolOption "Enable nvim-which-key.";
      vinegar = mkBoolOption "Enable vim-vinegar.";
    };

  config = lib.mkMerge ([
    {
      plugins = with lib; {
        ack = mkDefault true;
        commentary = mkDefault true;
        ctrlp = mkDefault true;
        git = mkDefault true;
        lastplace = mkDefault true;
        latex = mkDefault true;
        nix = mkDefault true;
        nvim-which-key = mkDefault true;
        vinegar = mkDefault true;
      };
    }
  ] ++ (lib.mapAttrsToList (plugin: config: lib.mkIf cfg.${plugin} config) configs));
}
