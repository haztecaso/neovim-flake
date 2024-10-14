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

    backupdir.__raw = "vim.fs.normalize('~/.local/share/nvim/backup/')";
    directory.__raw = "vim.fs.normalize('~/.local/share/nvim/swap/')";
    undodir.__raw = "vim.fs.normalize('~/.local/share/nvim/undo/')";

    undofile = true;
  };

  extraConfigLua = ''
    vim.cmd(':silent !mkdir -p $HOME/.local/share/nvim/backup')
    vim.cmd(':silent !mkdir -p $HOME/.local/share/nvim/swap')
    vim.cmd(':silent !mkdir -p $HOME/.local/share/nvim/undo')
  '';

  globals.mapleader = ",";

  keymaps = [
    { key = "<C-j>"; action = "<C-W>j"; }
    { key = "<C-k>"; action = "<C-W>k"; }
    { key = "<C-h>"; action = "<C-W>h"; }
    { key = "<C-l>"; action = "<C-W>l"; }
    {
      key = "<leader>o";
      action = "<C-W>\\|<C-W>_";
      options.desc = "Full screen pane";
    }
    {
      key = "<leader>i";
      action = "<C-W>=";
      options.desc = "Distribute panes equally";
    }

    {
      key = "gQ";
      action = "vipJgq<CR>";
      options.desc = "re-wrap paragraph";
    }

    {
      key = "<leader><Space>";
      action = ":nohlsearch<cr>";
      options.desc = "De-select current selection";
    }
  ];
}
