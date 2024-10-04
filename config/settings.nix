{
  opts = {
    number = true;
    textwidth = 80;
    colorcolumn = "80";
    ruler = true;
    cursorline = true;

    bg = "dark";
    autochdir = true;

    incsearch = true;
    hlsearch = true;
    ignorecase = true;
    smartcase = true;

    wildmenu = true;
    wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store";
    wildmode = "longest:full,full";

    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    smarttab = true;
    expandtab = true;

    autoindent = true;
    smartindent = true;

    splitbelow = true;
    splitright = true;

    backupdir = "$HOME/.local/share/nvim/backup/";
    directory = "$HOME/.local/share/nvim/swap/";
    undodir = "$HOME/.local/share/nvim/undo/";

    undofile = true;
  };

  extraConfigLua = ''
    vim.cmd(':silent !mkdir -p $HOME/.local/share/nvim/backup')
    vim.cmd(':silent !mkdir -p $HOME/.local/share/nvim/swap')
    vim.cmd(':silent !mkdir -p $HOME/.local/share/nvim/undo')
  '';
}
