{ config, lib, pkgs, ... }:
{
  startPlugins = with pkgs.neovimPlugins; [ 
    nvim-which-key
  ] ++ (with pkgs.vimPlugins; [
    vim-commentary
    vim-fugitive
    vim-lastplace
    vim-vinegar
    ack-vim
    vim-snippets
    vim-airline
    ctrlp
  ]);

  nnoremap = {
   "<leader>wc" = "<cmd>close<cr>";
   "<leader>wh" = "<cmd>split<cr>";
   "<leader>wv" = "<cmd>vsplit<cr>";
  };

  globals = {
    "ackprg" = "${pkgs.ag}/bin/ag --vimgrep";
    "airline#extensions#tabline#enabled" = "1";
    "airline_symbols_ascii" = "1"; 
    "ctrlp_show_hidden" = "1";
  };

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
