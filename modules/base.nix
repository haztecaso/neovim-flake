{ config, lib, pkgs, ... }:
{
  vim = {
    startPlugins = with pkgs.neovimPlugins; [ 
      nvim-which-key
    ] ++ (with pkgs.vimPlugins; [
      vim-commentary
      vim-fugitive
      vim-lastplace
      vim-nix
      vim-vinegar
      ack-vim
      vim-snippets
    ]);

    nnoremap = {
     "<leader>wc" = "<cmd>close<cr>";
     "<leader>wh" = "<cmd>split<cr>";
     "<leader>wv" = "<cmd>vsplit<cr>";
    };

    configRC = ''
      let g:ackprg = '${pkgs.ag}/bin/ag --vimgrep'
      map <leader>f :Ack!
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
  };
}
