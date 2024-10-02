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

    backupdir = "~/.local/share/nvim/backup/";
    directory = "~/.local/share/nvim/swap/";
    undodir = "~/.local/share/nvim/undo/";
    undofile = true;
  };

  extraConfigLua = ''
    if vim.fn.isdirectory('~/.local/share/nvim/backup/') == 0 then
      vim.cmd(':silent !mkdir -p ~/.local/share/nvim/backup')
    end
    if vim.fn.isdirectory('~/.local/share/nvim/swap/') == 0 then
      vim.cmd(':silent !mkdir -p ~/.local/share/nvim/swap')
    end
    if vim.fn.isdirectory('~/.local/share/nvim/undo/') == 0 then
      vim.cmd(':silent !mkdir -p ~/.local/share/nvim/undo')
    end
  '';
}
