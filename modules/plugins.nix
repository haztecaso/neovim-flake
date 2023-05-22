{ config, lib, pkgs, ... }:
let
  cfg = config.plugins;
  configs = {
    ack = {
      startPlugins = [ pkgs.vimPlugins.ack-vim ];
      globals.ackprg = "${pkgs.silver-searcher}/bin/ag --vimgrep";
    };
    commentary.startPlugins = [ pkgs.vimPlugins.vim-commentary ];
    enuch.startPlugins = [ pkgs.neovimPlugins.vim-enuch ];
    repeat.startPlugins = [ pkgs.vimPlugins.repeat ];
    ctrlp = {
      startPlugins = [ pkgs.vimPlugins.ctrlp ];
      globals."ctrlp_show_hidden" = "1";
      globals."ctrlp_custom_ignore" = ".git\|node_modules";
      globals."ctrlp_working_path_mode" = "ra";
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
        "vimtex_imaps_leader" = "ç";
        "vimtex_quickfix_autoclose_after_keystrokes" = 1;
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
    tidal = {
      startPlugins = [ pkgs.vimPlugins.vim-tidal ];
      globals = {
        "tidal_target" = "terminal";
      };
    };
    vim-visual-multi = {
      startPlugins = [ pkgs.vimPlugins.vim-visual-multi ];
    };
    neoformat = {
      startPlugins = [ pkgs.vimPlugins.neoformat ];
      globals = {
        "neoformat_try_node_exe" = "1";
      };
      configRC = ''
        autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.html,*.md,*.css,*.sass Neoformat
      '';
    };
    treesitter = {
      startPlugins = [ 
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [ bash
        beancount bibtex c cmake comment cpp css cuda diff dockerfile fish glsl
        go graphql haskell hjson html http java javascript jq jsdoc json json5 
        jsonc latex ledger llvm lua make markdown markdown_inline nix 
        norg ocaml org pascal php phpdoc python ql regex ruby rust scala scheme 
        scss sparql supercollider svelte terraform todotxt toml tsx typescript 
        vim vue yaml yaml ])) 
      ];
      luaConfigRC = ''
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<CR>",
              scope_incremental = "<CR>",
              node_incremental = "<TAB>",
              node_decremental = "<S-TAB>",
            },
          },
        }
      '';
      
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
      enuch = mkBoolOption "Enable vim-enuch.";
      git = mkBoolOption "Enable git support.";
      lastplace = mkBoolOption "Enable vim-lastplace.";
      latex = mkBoolOption "Enable latex support.";
      neoformat = mkBoolOption "Enable neoformat.";
      nix = mkBoolOption "Enable vim-nix.";
      nvim-which-key = mkBoolOption "Enable nvim-which-key.";
      repeat = mkBoolOption "Enable vim-repeat.";
      vim-visual-multi = mkBoolOption "Enable vim-visual-multi.";
      vinegar = mkBoolOption "Enable vim-vinegar.";
      tidal = mkBoolOption "Enable vim-tidal.";
      treesitter = mkBoolOption "Enable nvim-treesitter.";
    };

  config = lib.mkMerge ([
    {
      plugins = with lib; {
        ack = mkDefault true;
        commentary = mkDefault true;
        ctrlp = mkDefault true;
        enuch = mkDefault true;
        git = mkDefault true;
        lastplace = mkDefault true;
        latex = mkDefault true;
        neoformat = mkDefault true;
        nix = mkDefault true;
        nvim-which-key = mkDefault true;
        repeat = mkDefault true;
        vim-visual-multi = mkDefault true;
        vinegar = mkDefault true;
        tidal = mkDefault false;
        treesitter = mkDefault true;
      };
      configRC = if cfg.treesitter then "" else "syntax on";
    }
  ] ++ (lib.mapAttrsToList (plugin: config: lib.mkIf cfg.${plugin} config) configs));
}
