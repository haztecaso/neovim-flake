{
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

    # { key = "<leader>s"; action = ":setlocal spell!<CR>"; }
    # { key = "<leader>p"; action = ":setlocal paste!<CR>"; }

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
