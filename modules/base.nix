{ config, lib, pkgs, ... }:
{
  startPlugins = with pkgs.vimPlugins; with pkgs.neovimPlugins; [
    ack-vim
    ctrlp
    nvim-which-key
    vim-airline
    vim-commentary
    vim-fugitive
    vim-gitgutter
    vim-lastplace
    vim-snippets
    vim-vinegar
  ];

  nnoremap = {
   "<leader>wc" = "<cmd>close<cr>";
   "<leader>wh" = "<cmd>split<cr>";
   "<leader>wv" = "<cmd>vsplit<cr>";
  };

  globals = {
    "ackprg" = "${pkgs.ag}/bin/ag --vimgrep";
    "airline#extensions#tabline#enabled"     = "1";
    "airline_symbols_ascii"                  = "1"; 
    "ctrlp_show_hidden"                      = "1";
    "gitgutter_sign_added"                   = "+";
    "gitgutter_sign_modified"                = "~";
    "gitgutter_sign_removed"                 = "_";
    "gitgutter_sign_removed_first_line"      = "‾";
    "gitgutter_sign_removed_above_and_below" = "_¯";
    "gitgutter_sign_modified_removed"        = "~_";
  };

  configRC = ''
    set updatetime=100
  '';

  luaConfigRC = ''
    local wk = require("which-key")

    wk.register({
      w = {
        name = "window",
        c = { "Close Window"},
        h = { "Split Horizontal" },
        v = { "Split Vertical" },
      },
    }, { prefix = "<leader>" })
  '';
}
