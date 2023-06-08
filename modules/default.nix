{ pkgs, ... }:
{

  imports = [
    ./completion
    ./core.nix
    ./lsp
    ./plugins
    ./snippets.nix
  ];

  nnoremap = {
    "<leader><Space>" = ":nohlsearch<cr>";
    "<leader>o" = "<C-W>\\|<C-W>_";
    "<leader>i" = "<C-W>=";
    "<leader>s" = ":setlocal spell!<CR>";
    "<leader>p" = ":setlocal paste!<CR>";
    "gQ" = "vipJgq<CR>";
  };

  configRC = ''
    syntax on

    set textwidth=80
    set ruler
    "set nowrap

    set bg=dark

    set autochdir

    set incsearch
    set hlsearch
    set ignorecase
    set smartcase

    set wildmenu
    set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
    set wildmode=longest:full,full

    set colorcolumn=80
    set noshowcmd
  '';

}
